from rest_framework import serializers
from rest_framework.validators import UniqueValidator
from accounts.serializers import StudentSerializer, InvigilatorSerializer
from exam_seat.models import Course, Hall, SeatArrangement, AllocateHall

class CourseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Course
        fields = [
            "course_id",
            "dept_id",
            "course_title",
            "course_desc" 
        ]

class HallSerializer(serializers.ModelSerializer):
    name = serializers.CharField(validators = [UniqueValidator(queryset=Hall.objects.all(), message="Hall Already Exists")])
    class Meta:
        model = Hall
        fields = [
            'hall_id',
            'name', 
            'seat_no']


class AllocationsSerializer(serializers.ModelSerializer):
    course = CourseSerializer()
    invigilator = InvigilatorSerializer()
    class Meta:
        model = AllocateHall
        fields = [
            "user_id",
            "allocation_id",
            "date",
            "course",
            "level",
            "invigilator"
        ]

class AllocateHallSerializer(serializers.ModelSerializer):
    class Meta:
        model = AllocateHall
        fields = "__all__"

class SeatArrangementSerializer(serializers.ModelSerializer):
    allocation_id = AllocateHallSerializer()
    student_id = StudentSerializer()
    hall_id = HallSerializer()
    class Meta:
        model = SeatArrangement
        fields = [
            "seat_arrangement_id",
            "allocation_id",
            "hall_id",
            "student_id",
            "seat_no",
        ]