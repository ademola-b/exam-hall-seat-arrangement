from django.contrib.auth.hashers import make_password
from django.shortcuts import render
from rest_framework import status
from rest_framework.generics import ListCreateAPIView, CreateAPIView, UpdateAPIView
from rest_framework.response import Response

from . models import User, Student, Invigilator, Department
from . serializers import StudentSerializer, InvigilatorSerializer, ChangePasswordSerializer

default_password = '12345678'

# Create your views here.
class StudentCreateView(CreateAPIView):
    queryset = Student.objects.all()
    serializer_class = StudentSerializer

    def post(self, request):
        student_data = request.data
        student_serializer = StudentSerializer(data=student_data, many=True)
        # print(f'student: {student_data}')
        if student_serializer.is_valid():
            print(f'student: {student_data}')
            print(len(student_data))

            for data in student_data:
                print(f'data:{data}')
             
                user = User.objects.create(name = data['user_id']['name'],
                                    username = data['user_id']['username'],
                                    dept_id = Department.objects.get(dept_id = data['user_id']['dept_id']),
                                    password = make_password(default_password),
                                    is_student = True, 
                                    is_active=True)
                print(f'user: {user.name}')
                Student.objects.create(user_id = user, level = data['level'])

            return Response(student_serializer.data, status=status.HTTP_201_CREATED)
        else:
            print(f'student_errors: {student_serializer.errors}')
            return Response(student_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class InvigilatorView(ListCreateAPIView):
    queryset = Invigilator.objects.all()
    serializer_class = InvigilatorSerializer

    def get_queryset(self):
        qs = self.queryset

        if not self.request.user.is_authenticated:
            return qs.none()
        
        dept = self.request.user.dept_id
        if self.request.user.is_examofficer:
            qs = qs.filter(user_id__dept_id = dept)
            return qs
        
        return qs.none()

    def post(self, request):
        invigilator_data = request.data
        invigilator_serializer = InvigilatorSerializer(data=invigilator_data, many=True)
        # print(f'invigilator: {invigilator_data}')
        if invigilator_serializer.is_valid():
            print(f'invigilator: {invigilator_data}')

            for data in invigilator_data:
                user = User.objects.create(name = data['user_id']['name'],
                                    username = data['user_id']['username'],
                                    dept_id = Department.objects.get(dept_id = data['user_id']['dept_id']),
                                    password = make_password(default_password),
                                    is_invigilator = True, 
                                    is_active=True)
                Invigilator.objects.create(user_id = user, phone = data['phone'])

            return Response(invigilator_serializer.data, status=status.HTTP_201_CREATED)
        else:
            print(f'invigilator_errors: {invigilator_serializer.errors}')
            return Response(invigilator_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ChangePassword(UpdateAPIView):
    queryset = User.objects.all()
    serializer_class = ChangePasswordSerializer


