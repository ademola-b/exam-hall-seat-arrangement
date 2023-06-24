from django.contrib import admin
# from django.contrib.auth.admin import UserAdmin
from django.utils.translation import gettext as _
from . models import (User, Student, Invigilator)
# Register your models here.
class CustomUserAdmin(admin.ModelAdmin):
    fieldsets = (
        (None, {"fields": ("username", "password")}),
        (_("Personal info"), {"fields": ("first_name", "last_name", "email", "user_type")}),
        (
            _("Permissions"),
            {
                "fields": (
                    "is_active",
                    "is_staff",
                    "is_superuser",
                    "groups",
                    "user_permissions",
                ),
            },
        ),
        (_("Important dates"), {"fields": ("last_login", "date_joined")}),
    )
    list_display = ['username', 'dept_id', 'is_staff', 'is_examofficer', 'is_invigilator', 'is_student']


admin.site.register(User, CustomUserAdmin)
admin.site.register(Student)
admin.site.register(Invigilator)