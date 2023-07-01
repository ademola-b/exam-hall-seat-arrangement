from django.urls import path, include

from . views import StudentCreateView, InvigilatorView
urlpatterns = [
    path('', include('dj_rest_auth.urls')),
    path('add-student/', StudentCreateView.as_view(), name="Add Student"),
    path('invigilator/', InvigilatorView.as_view(), name="Invigilator"),
]
