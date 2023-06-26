from django.shortcuts import render
from rest_framework import status
from rest_framework.generics import CreateAPIView
from rest_framework.response import Response

from . models import Hall
from . serializers import HallSerializer
# Create your views here.
class HallCreateView(CreateAPIView):
    queryset = Hall.objects.all()
    serializer_class = HallSerializer

    # def get_queryset(self):
    #     # qs = Hall.objects.all()
    #     if not self.request.user.is_authenticated:
    #         return Hall.objects.none()
    #     return Hall.objects.filter(user_id=self.request.user)
    

    def post(self, request):
        hall_data = request.data
        # data = {
        #     'name':hall_data['name'],
        #     'seat_no': hall_data['seat_no'],
        # }

        hall_serializer = HallSerializer(data=hall_data, many=True)
        if hall_serializer.is_valid():
            for i in hall_data:
                Hall.objects.create(
                    user_id = request.user,
                    name = i['name'],
                    seat_no= i['seat_no'],
                )
          
            return Response(hall_serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(hall_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
