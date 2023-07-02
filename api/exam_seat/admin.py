from django.contrib import admin
from . models import (
    Department, Course, Session,
    Hall, AllocateHall, SeatArrangement
)
# Register your models here.
class AllocationModelAdmin(admin.ModelAdmin):
    list_display = ('date', 'course', 'level', 'invigilator')
    ordering = ('date',)

admin.site.register(AllocateHall, AllocationModelAdmin)

modelList = [
    Department, Course, Session, Hall,
    SeatArrangement
]

for model in modelList:
    admin.site.register(model)
