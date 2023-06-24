from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.utils.translation import gettext as _
from . models import (User, Student, Invigilator)
# Register your models here.
class UserAdmin(UserAdmin):
    list_display = ('username', 'name', 'dept_id', 'date_joined', 'last_login', 'is_examofficer', 'is_student', 'is_invigilator', 'is_staff', 'is_superuser',)
    search_fields = ('username','name','email',)
    ordering = ('username',)
    readonly_fields = ('date_joined', 'last_login',)

    filter_horizontal = ()
    list_filter = ()
    fieldsets = ()

admin.site.register(User, UserAdmin)
admin.site.register(Student)
admin.site.register(Invigilator)