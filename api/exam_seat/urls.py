from django.urls import path
from . views import (CourseView, HallView, SeatArrangementView, 
                     SeatArrangementCreate)

urlpatterns = [
    path('add-hall/', HallView.as_view(), name="Add_Hall"),
    path('halls/', HallView.as_view(), name="Halls"),
    path('halls/<str:hall_id>/', HallView.as_view(), name="Halls"),
    path('courses/', CourseView.as_view(), name="Courses"),
    path('courses/<str:course_id>/', CourseView.as_view(), name="Courses"),
    # path('seat-arrangement/', SeatArrangementCreate.as_view(), name="Seat Arrangement"),
    path('seat-arrangement/<str:date>/', SeatArrangementView.as_view(), name="Seat Arrangement"),
    path('seat-arrangement/<str:date>/<str:hall>/<str:course>/', SeatArrangementView.as_view(), name="Seat Arrangement(Exam Officer)"),
]

