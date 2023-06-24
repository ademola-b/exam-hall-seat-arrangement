from rest_framework import serializers
from dj_rest_auth.serializers import UserDetailsSerializer
from . models import User

class UserDetailsSerializer(UserDetailsSerializer):

    dept_id = serializers.StringRelatedField()

    class Meta(UserDetailsSerializer.Meta):
        fields = UserDetailsSerializer.Meta.fields + ('name', 'dept_id', 'is_staff', 'is_examofficer', 'is_student', 'is_invigilator')
        read_only_fields = ('username', 'name', 'dept_id', 'is_staff', 'is_examofficer', 'is_student', 'is_invigilator')