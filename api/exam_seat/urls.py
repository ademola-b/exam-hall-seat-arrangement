from django.urls import path
from . views import (CourseView, HallView, SeatArrangementView, 
                     AllocateHallView, AllocationsView, 
                     UpdateDeleteAllocationView, HallDelete)

urlpatterns = [
    path('add-hall/', HallView.as_view(), name="Add_Hall"),
    path('allocations/', AllocationsView.as_view(), name="Allocations"),
    path('allocations/<str:date>/', AllocationsView.as_view(), name="Allocations"),
    path('allocations/modify/<str:pk>/', UpdateDeleteAllocationView.as_view(), name="Delete Allocations"),
    path('allocate-hall/', AllocateHallView.as_view(), name="Allocate Hall"),
    path('halls/', HallView.as_view(), name="Halls"),
    path('halls/<str:hall_id>/', HallView.as_view(), name="Halls"),
    path('hall/delete/<str:pk>/', HallDelete.as_view(), name="Halls"),
    path('courses/', CourseView.as_view(), name="Courses"),
    path('courses/<str:course_id>/', CourseView.as_view(), name="Courses"),
    # path('seat-arrangement/', SeatArrangementCreate.as_view(), name="Seat Arrangement"),
    path('seat-arrangement/<str:date>/', SeatArrangementView.as_view(), name="Seat Arrangement"),
    path('seat-arrangement/<str:date>/<str:hall>/<str:course>/', SeatArrangementView.as_view(), name="Seat Arrangement(Exam Officer)"),
]

    