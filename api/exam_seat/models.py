import uuid
# from accounts.models import Invigilator, Student
from django.db import models

# Create your models here.
class Department(models.Model):
    dept_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    dept_name = models.CharField(max_length=50, blank=True, null=True)

    def __str__(self):
        return self.dept_name
    
class Course(models.Model):
    course_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    dept_id = models.ForeignKey(Department, on_delete=models.CASCADE, blank=True, null=True)
    course_title = models.CharField(max_length=7)
    course_desc = models.CharField(max_length=100)

    def __str__(self):
        return f"{self.course_title} - {self.course_desc}"

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
    user_id = models.ForeignKey("accounts.User", blank=True, null=True, on_delete=models.SET_NULL)
    allocation_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    date = models.DateTimeField()
    course = models.ForeignKey(Course, on_delete=models.CASCADE, null=True, blank=True)
    level = models.CharField(max_length=10, choices=[('1', 'ND I'), ('2', 'ND II'),('3', 'HND I'),('4', 'HND II'),])
    invigilator = models.ForeignKey("accounts.Invigilator", on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.date} - {self.course.course_desc}"

class SeatArrangement(models.Model):
    seat_arrangement_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    allocation_id = models.ForeignKey(AllocateHall, on_delete=models.CASCADE)
    hall_id = models.ForeignKey(Hall, on_delete=models.CASCADE, null=True, blank=True)
    student_id = models.ForeignKey("accounts.Student", on_delete=models.CASCADE)
    seat_no = models.IntegerField(blank=True, null=True)

    def __str__(self):
        return f"{self.student_id.user_id.username} allocated to {self.hall_id.name} on seat number {self.seat_no} to write {self.allocation_id.course.course_desc}"
