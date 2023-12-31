from typing import Any
import uuid
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.db import models
from exam_seat.models import Department, Session
# Create your models here.

class UserManager(BaseUserManager):
    def create_user(self, username, name, password=None):
        if username is None:
            raise ValueError('Username is required')
        
        if name is None:
            raise ValueError('Name is required')
        
        if password is None:
            raise ValueError('Password is required')
        
        user = self.model(
            username = username,
            name = name.title().strip()
        )

        user.set_password(password)
        user.save(using = self._db)

        return user
    
    def create_superuser(self, username, name, password=None):
        user = self.create_user(
            username = username,
            name = name,
            password = password
        )

        user.is_staff = True
        user.is_superuser = True
        user.is_active = True
        user.save(using = self._db)

        return user

class User(AbstractBaseUser):
    user_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    username = models.CharField(max_length=100, db_index=True, unique=True, blank=True, null=True)
    name = models.CharField(max_length=100, db_index=True, blank=True, null=True)
    dept_id = models.ForeignKey(Department, on_delete=models.CASCADE, blank=True, null=True)

    date_joined = models.DateTimeField(
        verbose_name='date_joined', auto_now_add=True)
    last_login = models.DateTimeField(
        verbose_name='last_login', auto_now=True, null=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    is_examofficer = models.BooleanField(default=False)
    is_student = models.BooleanField(default=False)
    is_invigilator = models.BooleanField(default=False)

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['name']

    objects = UserManager()

    def _str_(self):
        return f'{self.username}'

    def has_perm(self, perm, obj=None):
        return self.is_staff

    def has_module_perms(self, app_label):
        return True

    class Meta:
        db_table = 'User'
        verbose_name_plural = 'Users'

class Student(models.Model):
    profile_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    user_id = models.OneToOneField(User, on_delete=models.CASCADE, blank=True, null=True)
    session_id = models.ForeignKey(Session, on_delete=models.CASCADE, blank=True, null=True)
    level = models.CharField(max_length=10, choices=[('1', 'ND I'), ('2', 'ND II'),('3', 'HND I'),('4', 'HND II'),])

    def __str__(self):
        return self.user_id.username
    

class Invigilator(models.Model):
    profile_id = models.UUIDField(default=uuid.uuid4, primary_key=True, unique=True, editable=False)
    user_id = models.OneToOneField(User, on_delete=models.CASCADE, blank=True, null=True)
    phone = models.CharField(max_length=11, blank=True, null=True)

    def __str__(self):
        return self.user_id.username
    

    