from django.contrib.auth.hashers import make_password
from django.shortcuts import render
from rest_framework import status
from rest_framework.generics import CreateAPIView
from rest_framework.response import Response

from . models import User, Student, Department
from . serializers import StudentSerializer

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
                # user = User.objects.create(name = data['name'],
                #                     username = data['username'],
                #                     dept_id = Department.objects.get(dept_id = data['dept_id']),
                #                     password = make_password(default_password),
                #                     is_student = True, 
                #                     is_active=True)
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

