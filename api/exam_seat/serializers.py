from rest_framework import serializers
from rest_framework.validators import UniqueValidator
from accounts.serializers import StudentSerializer
from exam_seat.models import Hall, SeatArrangement, AllocateHall

class HallSerializer(serializers.ModelSerializer):
    name = serializers.CharField(validators = [UniqueValidator(queryset=Hall.objects.all(), message="Hall Already Exists")])
    class Meta:
        model = Hall
        fields = [
            'hall_id',
            'name', 
            'seat_no']


class AllocationSerializer(serializers.ModelSerializer):
    hall_id = HallSerializer()
    class Meta:
        model = AllocateHall
        fields = [
            "allocation_id",
            "date",
            "semester",
            "hall_id",
            "no_seat",
            "level",
            "invigilator"
        ]


class SeatArrangementSerializer(serializers.ModelSerializer):
    allocation_id = AllocationSerializer()
    # student_id = StudentSerializer()
    class Meta:
        model = SeatArrangement
        fields = [
            "seat_arrangement_id",
            "allocation_id",
            "student_id",
            "seat_no",
        ]