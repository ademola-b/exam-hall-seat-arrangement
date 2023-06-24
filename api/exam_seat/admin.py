from django.contrib import admin
from . models import (
    Department, Session,
    Hall, AllocateHall, SeatArrangement
)
# Register your models here.
admin.site.register(Department)
admin.site.register(Session)
admin.site.register(Hall)
admin.site.register(AllocateHall)
admin.site.register(SeatArrangement)