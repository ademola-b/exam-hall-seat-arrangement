import uuid
# from accounts.models import Invigilator, Student
from django.db import models

# Create your models here.
class Department(models.Model):
    dept_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    dept_name = models.CharField(max_length=50, blank=True, null=True)

    def __str__(self):
        return self.dept_name 
    
class Session(models.Model):
    session_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    session_title = models.CharField(max_length=50, blank=True, null=True)

    def __str__(self):
        return self.session_title

class Hall(models.Model):
    user_id = models.ForeignKey("accounts.User", blank=True, null=True, on_delete=models.SET_NULL)
    hall_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    name = models.CharField(max_length=100, blank=True, null=True)
    seat_no = models.IntegerField(blank=True, null=True)

    def __str__(self):
        return f"{self.name}"

class AllocateHall(models.Model):
    allocation_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    date = models.DateTimeField()
    semester = models.CharField(max_length=4, choices=[('1', '1st'),('2', '2nd'),('3', '3rd'),('4', '4th')])
    hall_id = models.ForeignKey(Hall, on_delete=models.CASCADE)
    no_seat = models.IntegerField(blank=True, null=True)
    level = models.CharField(max_length=10, choices=[('1', 'ND I'), ('2', 'ND II'),('3', 'HND I'),('4', 'HND II'),])
    invigilator = models.ForeignKey("accounts.Invigilator", on_delete=models.CASCADE)

class SeatArrangement(models.Model):
    seat_arrangement_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    allocation_id = models.ForeignKey(AllocateHall, on_delete=models.CASCADE)
    student_id = models.ForeignKey("accounts.Student", on_delete=models.CASCADE)
    seat_no = models.IntegerField(blank=True, null=True)
