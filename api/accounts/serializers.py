from rest_framework import serializers
from dj_rest_auth.serializers import UserDetailsSerializer, PasswordChangeSerializer
from . models import (User, Student, 
                      Invigilator, Department)

class DepartmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Department
        fields = [
            'dept_id',
            'dept_name'
        ]

class UserDetailsSerializer(UserDetailsSerializer):

    # dept_id = serializers.StringRelatedField()
    # dept_id = DepartmentSerializer()

    class Meta(UserDetailsSerializer.Meta):
        # fields = UserDetailsSerializer.Meta.fields + ('name', 'dept_id', 'is_staff', 'is_examofficer', 'is_student', 'is_invigilator')
        fields = [
            'pk',
            'name',
            'username',
            'dept_id', 
            'is_staff', 
            'is_examofficer', 
            'is_student', 
            'is_invigilator'
        ]
        read_only_fields = ('is_staff', 'is_examofficer', 'is_student', 'is_invigilator')

class ChangePasswordSerializer(PasswordChangeSerializer):
    old_password = serializers.CharField(required=True)


class StudentSerializer(serializers.ModelSerializer):

    user_id = UserDetailsSerializer(required=False)

    class Meta:
        model = Student
        fields = [
            'user_id',
            'level'
        ]
        
class InvigilatorSerializer(serializers.ModelSerializer):

    user_id = UserDetailsSerializer(required=False)

    class Meta:
        model = Invigilator
        fields = [
            'profile_id',
            'user_id',
            'phone'
        ]
