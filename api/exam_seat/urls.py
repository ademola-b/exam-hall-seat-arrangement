from django.urls import path
from . views import HallCreateView

urlpatterns = [
    path('add-hall/', HallCreateView.as_view(), name="Add_Hall")
]

