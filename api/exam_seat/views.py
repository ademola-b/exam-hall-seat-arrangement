from django.shortcuts import render
from rest_framework import status
from rest_framework.generics import CreateAPIView, ListAPIView, ListCreateAPIView
from rest_framework.response import Response

from . models import Hall, SeatArrangement, Course
from . serializers import HallSerializer, SeatArrangementSerializer, CourseSerializer
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

class SeatArrangementCreate(CreateAPIView):
    queryset = SeatArrangement.objects.all()
    serializer_class = SeatArrangementSerializer

    def post(self, request):
        seat_arrangement_data = request.data
        seat_arrangement_serializer = SeatArrangementSerializer(data = seat_arrangement_data, many=True)
        if seat_arrangement_serializer.is_valid():
            for data in seat_arrangement_data:
                SeatArrangement.objects.update_or_create(defaults={'allocation_id':data['allocation_id']},
                                                         student_id=data['student_id'],
                                                         seat_no=data['seat_no'])

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
()


