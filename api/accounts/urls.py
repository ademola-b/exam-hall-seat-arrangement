from django.urls import path, include

from . views import StudentCreateView
urlpatterns = [
    path('', include('dj_rest_auth.urls')),
    path('add-student/', StudentCreateView.as_view(), name="Add Student"),
]
