from rest_framework import serializers
from rest_framework.validators import UniqueValidator
from exam_seat.models import Hall

class HallSerializer(serializers.ModelSerializer):
    name = serializers.CharField(validators = [UniqueValidator(queryset=Hall.objects.all(), message="Hall Already Exists")])
    class Meta:
        model = Hall
        fields = [
            'hall_id',
            'name', 
            'seat_no']
        
