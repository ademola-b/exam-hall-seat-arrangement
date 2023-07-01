from random import shuffle

from django.shortcuts import render
from rest_framework import status
from rest_framework.generics import CreateAPIView, ListAPIView, ListCreateAPIView
from rest_framework.response import Response

from accounts.models import Student, Invigilator

from . models import Hall, SeatArrangement, Course, AllocateHall
from . serializers import (HallSerializer, SeatArrangementSerializer, 
                           CourseSerializer, AllocateHallSerializer)
# Create your views here.
class HallView(ListCreateAPIView):
    queryset = Hall.objects.all()
    serializer_class = HallSerializer  

    def get_queryset(self):
        qs = self.queryset
        request = self.request
        user = request.user
        
        if not user.is_authenticated:
            return Hall.objects.none() 
    
        if user.is_examofficer:
            hall_id = self.kwargs.get('hall_id')
            if hall_id is not None:
                qs = qs.filter(user_id = user, hall_id = hall_id)
                return qs
            else:
                qs = qs.filter(user_id = user)
                return qs
        else:
            return Hall.objects.none() 
                    
    def post(self, request):
        hall_data = request.data
        hall_serializer = HallSerializer(data=hall_data, many=True)
        if hall_serializer.is_valid():
            for i in hall_data:
                Hall.objects.create(
                    user_id = request.user,
                    name = i['name'],
                    seat_no= i['seat_no'],
                )
          
            return Response(hall_serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(hall_serializer.errors, status=status.HTTP_400_BAD_REQUEST)    

class CourseView(ListAPIView):
    queryset = Course.objects.all()
    serializer_class = CourseSerializer

    def get_queryset(self):
        course_id = self.kwargs.get('course_id')
        if course_id is not None:
            return self.queryset.filter(course_id=course_id)
        else:
            return Course.objects.all()

# class SeatArrangementCreate(CreateAPIView):
#     queryset = SeatArrangement.objects.all()
#     serializer_class = SeatArrangementSerializer

#     def post(self, request):
#         seat_arrangement_data = request.data
#         seat_arrangement_serializer = SeatArrangementSerializer(data = seat_arrangement_data, many=True)
#         if seat_arrangement_serializer.is_valid():
#             for data in seat_arrangement_data:
#                 SeatArrangement.objects.update_or_create(defaults={'allocation_id':data['allocation_id']},
#                                                          student_id=data['student_id'],
#                                                          seat_no=data['seat_no'])

class SeatArrangementView(ListAPIView):
    serializer_class = SeatArrangementSerializer
    
    def get_queryset(self, *args, **kwargs):
        qs = SeatArrangement.objects.all()
        date = self.kwargs.get('date')
        hall = self.kwargs.get('hall')
        course = self.kwargs.get('course')
        request = self.request
        user = request.user
        
        if date is not None:
            if user.is_student:
                qs = qs.filter(allocation_id__date__date=date, student_id=self.request.user.student)
                return qs
            elif user.is_invigilator:
                qs = qs.filter(allocation_id__date__date=date, allocation_id__invigilator=self.request.user.invigilator)
                return qs
            elif user.is_examofficer:
                if hall and course:
                    qs = qs.filter(allocation_id__date__date=date, allocation_id__hall_id=hall, allocation_id__course=course)
                    return qs
                

def allocate_students_to_halls(num_students, num_halls, hall_cap):
    # Calculate the maximum number of students per hall
    max_students_per_hall = num_students // num_halls
    remaining_students = num_students % num_halls

     # Sort the halls based on their capacity
    sorted_halls = sorted(range(num_halls), key=lambda x: hall_cap[x])

    # Initialize the seating allocation dictionary
    seating_allocation = {hall: [] for hall in range(num_halls)}

    # Initialize student ID
    students = [x for x in range(1, num_students +1)]
    shuffle(students)

    if num_students > sum(hall_cap):
        return None
    else:
        # allocate max number of students to each hall
        for hall in sorted_halls:
            for _ in range(max_students_per_hall):
                # get seat number
                seat_number = len(seating_allocation[hall]) + 1
                # append student and seat number to dict
                seating_allocation[hall].append((students.pop(0), seat_number))

        # calculate and get the remaining seats in each hall
        remaining_seats = {
            hall: list(range(len(seating_allocation[hall]) + 1, hall_cap[hall] + 1))
            for hall in sorted_halls
        }

        # distribute the remaining students evenly across the halls
        for hall in sorted_halls:
            while len(seating_allocation[hall]) < hall_cap[hall] and remaining_students > 0:
                # remove seat number from dict
                seat_number = remaining_seats[hall].pop(0)
                # add student and seat number to dict
                seating_allocation[hall].append((students.pop(0), seat_number))
                remaining_students -=1
        
        return seating_allocation


class AllocateHallView(CreateAPIView):
    queryset = AllocateHall.objects.all()
    serializer_class = AllocateHallSerializer


    def post(self, request):
        allocation_data = request.data
        allocation_serializer = AllocateHallSerializer(data=allocation_data)
        dept = request.user.dept_id
        print(f"allocation_data: {allocation_data}")

        if allocation_serializer.is_valid():

            # save allocation
            allocate_hall = AllocateHall.objects.create(
                date = allocation_data['date'],
                course = Course.objects.get(course_id = allocation_data['course']),
                level = allocation_data['level'],
                invigilator = Invigilator.objects.get(profile_id = allocation_data['invigilator']) 
            )

            # get hall seat number
            halls = Hall.objects.filter(user_id = self.request.user)

            # get students in selected level and department
            students = list(Student.objects.filter(user_id__dept_id=dept, level=allocation_data['level']).values_list('profile_id', flat=True))
            shuffle(students)

            num_students = len(students)
            num_halls = len(halls)
            hall_cap = [hall.seat_no for hall in halls]

            # print(f"hall_cap:{hall_cap}")
            
            max_students_per_hall = num_students  // num_halls
            remaining_students = num_students % num_halls

            sorted_halls = sorted(halls, key=lambda hall: hall.seat_no)


            seating_allocation = {hall: [] for hall in sorted_halls}


            if num_students > sum(hall_cap):
                print("Shortage of seats number, get more seats")
                return None
            else:
                remaining_seats = {}

                for hall in sorted_halls:
                    seats = list(range(1, hall.seat_no + 1))
                    for _ in range(max_students_per_hall):
                        if seats:
                            seating_allocation[hall].append([students.pop(0), seats.pop(0)])
                            print(f"seatAlloc: {seating_allocation}")
                            remaining_seats[hall] = seats
                        else:
                            break


                # Distribute any remaining students evenly across the halls
                for hall in sorted_halls:
                    print(f"len remaining seat: {len(remaining_seats[hall])}")
                    print(f"hall_cap: {hall.seat_no}")
                    print(f"remaining student: {remaining_students}")

                    while len(remaining_seats[hall]) < hall.seat_no and remaining_students > 0:
                        seat_number = remaining_seats[hall.seats].pop(0)
                        seating_allocation[hall].append((students.pop(0), seat_number))
                        remaining_students -=1


            seating_list = [[hall] + seat for hall, seats in seating_allocation.items() for seat in seats]
           

            print(f"seating_list: {seating_list}")

            for seatArr in seating_list:
                print(f"seatFromList: {seatArr}")
                SeatArrangement.objects.create(
                    allocation_id = allocate_hall,
                    hall_id = seatArr[0],
                    student_id = Student.objects.get(profile_id = seatArr[1]),
                    seat_no = seatArr[2],
                )

            return Response(data=allocation_serializer.data, status=status.HTTP_201_CREATED)   
        else:
            return Response(data=allocation_serializer.errors, status=status.HTTP_400_BAD_REQUEST)       
            

