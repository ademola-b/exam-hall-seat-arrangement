from django.contrib import admin
from . models import (
    Department, Course, Session,
    Hall, AllocateHall, SeatArrangement
)
# Register your models here.
modelList = [
    Department, Course, Session, Hall,
    AllocateHall, SeatArrangement
]

for model in modelList:
    admin.site.register(model)
