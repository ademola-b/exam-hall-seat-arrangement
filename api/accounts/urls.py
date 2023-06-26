from django.urls import path, include

from . views import StudentCreateView, InvigilatorCreateView
urlpatterns = [
    path('', include('dj_rest_auth.urls')),
    path('add-student/', StudentCreateView.as_view(), name="Add Student"),
    path('add-invigilator/', InvigilatorCreateView.as_view(), name="Add Invigilator"),
]
