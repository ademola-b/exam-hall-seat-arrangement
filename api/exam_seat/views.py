from random import shuffle

from django.shortcuts import render
from rest_framework import status, serializers
from rest_framework.generics import (CreateAPIView, ListAPIView, ListCreateAPIView,
                                     RetrieveUpdateDestroyAPIView, DestroyAPIView)
from rest_framework.response import Response

from accounts.models import User, Student, Invigilator

from . models import Hall, SeatArrangement, Course, AllocateHall
from . serializers import (HallSerializer, SeatArrangementSerializer, 
                           CourseSerializer, AllocateHallSerializer, AllocationsSerializer)
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

class HallDelete(DestroyAPIView):
    queryset = Hall.objects.all()
    serializer_class = HallSerializer

    # def get_queryset(self):
    #     qs = self.queryset
    #     if not self.request.user.is_authenticated:
    #         return Hall.objects.none
    #     if self.request.user.is_examofficer:
    #         hall_id = self.kwargs.get('hall_id')
    #         if hall_id is not None:
    #             qs = qs.filter(user_id = self.request.user, hall_id = hall_id)
    #             return qs
    #         else:
    #             qs = qs.filter(user_id = self.request.user)
    #             return qs
    #     else:
    #         return Hall.objects.none
    

class CourseView(ListAPIView):
    queryset = Course.objects.all()
    serializer_class = CourseSerializer

    def get_queryset(self):
        course_id = self.kwargs.get('course_id')
        if course_id is not None:
            return self.queryset.filter(course_id=course_id)
        else:
            return Course.objects.all()

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
                    qs = qs.filter(allocation_id__date__date=date, hall_id=hall, allocation_id__course=course)
                    return qs
                else:
                    return qs.filter(allocation_id__date__date=date)

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

            if AllocateHall.objects.filter(date =  allocation_data['date'], level = allocation_data['level'], course_id = allocation_data['course']).exists():
                return Response({'exists': "Allocation already done on this date and course"}, status=status.HTTP_400_BAD_REQUEST)
            else:

                try:
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
                    # print(f"max_students_per_hall:{max_students_per_hall}")

                    # allocate only if max. stds. per hall is greater than 0
                    if max_students_per_hall >= 1:
                        sorted_halls = sorted(halls, key=lambda hall: hall.seat_no)
                        seating_allocation = {hall: [] for hall in sorted_halls}

                        if num_students > sum(hall_cap):
                            return Response({"hall_shortage": "Shortage of seats, kindly get more halls"}, status=status.HTTP_400_BAD_REQUEST)
                        else:
                            remaining_seats = {}

                            for hall in sorted_halls:
                                seats = list(range(1, hall.seat_no + 1))
                                for _ in range(max_students_per_hall):
                                    if seats and students:
                                        seating_allocation[hall].append([students.pop(0), seats.pop(0)])
                                        print(f"seatAlloc: {seating_allocation}")
                                        remaining_seats[hall] = seats
                                    else:
                                        break


                            # Distribute any remaining students evenly across the halls
                            for hall in sorted_halls:
                                print(f"remaining seat: {remaining_seats[hall]}")
                                # print(f"hall_cap: {hall.seat_no}")
                                # print(f"remaining student: {remaining_stuWdents}")

                                # seats = list(range(1, remaining_seats[hall] + 1))
                                # print(seats)
                                while len(remaining_seats[hall]) < hall.seat_no and remaining_students > 0:
                                    seat_number = remaining_seats[hall].pop(0)
                                    seating_allocation[hall].append([students.pop(0), seat_number])
                                    remaining_students -=1
                    else:
                        return Response({"zero_max":"Students can't be allocated, kindly use the manual method"}, status=status.HTTP_400_BAD_REQUEST)

                    seating_list = [[hall] + seat for hall, seats in seating_allocation.items() for seat in seats]
        
                    print(f"seating_list: {seating_list}")

                    # save allocation
                    allocate_hall = AllocateHall.objects.create(
                        user_id = User.objects.get(user_id = self.request.user.pk),
                        date = allocation_data['date'],
                        course = Course.objects.get(course_id = allocation_data['course']),
                        level = allocation_data['level'],
                        invigilator = Invigilator.objects.get(profile_id = allocation_data['invigilator']) 
                    )

                    for seatArr in seating_list:
                        print(f"seatFromList: {seatArr}")
                        SeatArrangement.objects.create(
                            allocation_id = allocate_hall,
                            hall_id = seatArr[0],
                            student_id = Student.objects.get(profile_id = seatArr[1]),
                            seat_no = seatArr[2],
                        )

                    return Response(data=allocation_serializer.data, status=status.HTTP_201_CREATED)  
                except ZeroDivisionError:
                    return Response({"empty_hall": "No hall to allocate"}, status=status.HTTP_400_BAD_REQUEST)
                
        else:
            print(f"Errors: {allocation_serializer.errors}")
            return Response(data=allocation_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        

class AllocationsView(ListAPIView):
    queryset = AllocateHall.objects.all().order_by('date')
    serializer_class = AllocationsSerializer

    def get_queryset(self):

        date = self.kwargs.get('date')

        if not self.request.user.is_authenticated or not self.request.user.is_examofficer:
            return self.queryset.none()
        
        if self.request.user.is_examofficer:
            if date:
                return self.queryset.filter(user_id=self.request.user, date__date=date)
            else:
                return self.queryset.filter(user_id=self.request.user)
        
        return super().get_queryset()
    
class UpdateDeleteAllocationView(RetrieveUpdateDestroyAPIView):
    queryset = AllocateHall.objects.all()
    serializer_class = AllocateHallSerializer

    def delete(self, request, *args, **kwargs):
        allocation_id = self.kwargs.get('pk')
        AllocateHall.objects.get(allocation_id = allocation_id).delete()
        seat_arrangements = SeatArrangement.objects.filter(allocation_id = allocation_id)
        print(f"seats:{seat_arrangements}")
        # seat_arrangements.delete()
        if seat_arrangements.delete():
            return Response({"delete": "Seat Arrangements Deleted"}, status=status.HTTP_200_OK)
        return super().delete(request, *args, **kwargs)
            

