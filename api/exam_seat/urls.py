from django.urls import path
from . views import (HallCreateView, SeatArrangementView, 
                     SeatArrangementCreate)

urlpatterns = [
    path('add-hall/', HallCreateView.as_view(), name="Add_Hall"),
    path('seat-arrangement/', SeatArrangementCreate.as_view(), name="Seat Arrangement"),
    path('seat-arrangement/<str:date>/', SeatArrangementView.as_view(), name="Seat Arrangement"),
]

