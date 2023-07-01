import random

def allocate_students_to_halls(num_students, num_halls, hall_capacities):
    # Calculate the maximum number of students per hall
    max_students_per_hall = num_students // num_halls
    remaining_students = num_students % num_halls

    # Sort the halls based on their capacity
    sorted_halls = sorted(range(num_halls), key=lambda x: hall_capacities[x])

    # Initialize the seating allocation dictionary
    seating_allocation = {hall: [] for hall in range(num_halls)}

    # Initialize student ID
    students = [x for x in range(1, num_students +1)]
    random.shuffle(students)
    
    print(f"students: {students}")
    print(f"sum of hall seats: {sum(hall_capacities)}")
    # check if the students length is greater than the seats available
    if num_students > sum(hall_capacities):
        print("Shortage of seats number, get more seats")
    else:

        # Allocate the maximum number of students to each hall
        for hall in sorted_halls:
            # seats = list(range(1, hall_capacities[hall] + 1))
            # random.shuffle(seats)  # Randomize the seat numbers
            for _ in range(max_students_per_hall):
                # seat_number = seats.pop(0)
                seat_number = len(seating_allocation[hall]) + 1
                seating_allocation[hall].append((students.pop(0), seat_number))
                # student_id += 1
                # print(f"rem: {students}")
                print()
            # print(f"seats: {hall} - {seats}")
        
        # cal the remaining seat in each hall
        remaining_seats = {
            hall: list(range(len(seating_allocation[hall]) + 1, hall_capacities[hall] + 1))
            for hall in sorted_halls
        }
        print(f"remaining seats: {hall_capacities[hall]}")

        # Distribute any remaining students evenly across the halls
        for hall in sorted_halls:
            while len(seating_allocation[hall]) < hall_capacities[hall] and remaining_students > 0:
                # seat_number = len(seating_allocation[hall]) + 1
                seat_number = remaining_seats[hall].pop(0)
                seating_allocation[hall].append((students.pop(0), seat_number))
                remaining_students -=1
                

        return seating_allocation

# Example usage
num_students = 19
num_halls = 4
hall_capacities = [5, 5, 4, 6]  # Capacity of each hall

seating_allocation = allocate_students_to_halls(num_students, num_halls, hall_capacities)

print(f"seating alloc: {seating_allocation}")
print(f"data type: {type(seating_allocation)}")

# Print the seating allocation for each hall
# if seating_allocation is not None:
#     for hall, students in seating_allocation.items():
#         print(f"Hall {hall + 1}:")
#         for student_id, seat_number in students:
#             print(f"Student {student_id}: Seat {seat_number}")
#         print()

#     # print the remaining seat numbers for each hall
#     for hall, seat_numbers in seating_allocation.items():
#         print(f"Hall {hall + 1}:")
#         remaining_seats = [
#             seat_number for seat_number in range(len(seat_numbers) + 1, hall_capacities[hall] + 1)

#         ]

#         print(f"remaining seat number: {remaining_seats}")
#         print()
# else:
#     print("Allocation was not made")


# dumps
'''
def post(self, request):
        allocation_data = request.data
        allocation_serializer = AllocateHallSerializer(data=allocation_data)
        dept = request.user.dept_id
        print(f"allocation_data: {allocation_data}")

        if allocation_serializer.is_valid():

            # save allocation
            # allocate_hall = AllocateHall.objects.create(
            #     date = allocation_data['date'],
            #     course = Course.objects.get(course_id = allocation_data['course']) ,
            #     hall_id = Hall.objects.get(hall_id = allocation_data['hall_id']) ,
            #     # no_seat = allocation_data['no_seat'],
            #     level = allocation_data['level'],
            #     invigilator = Invigilator.objects.get(profile_id = allocation_data['invigilator']) 
            # )
            # get hall seat number
            hall_seat_no = Hall.objects.get(hall_id = allocation_data['hall_id'])
            halls = Hall.objects.filter(user_id = self.request.user)

            # print(f"Halls: {halls}")
            # get students in selected level and department
            students = list(Student.objects.filter(user_id__dept_id=dept, level=allocation_data['level']).values_list('profile_id', flat=True))
            # students = list(Student.objects.filter(user_id__dept_id=dept, level=allocation_data['level']))
            shuffle(students)
            seatsInHall = [i for i in range(1, hall_seat_no.seat_no + 1)]
            shuffle(seatsInHall)

            num_students = len(students)
            num_halls = len(halls)
            hall_cap = [hall.seat_no for hall in halls]

            print(f"hall_cap:{hall_cap}")
            
            max_students_per_hall = num_students  // num_halls
            remaining_students = num_students % num_halls

            # sorted_halls = Hall.objects.filter(user_id=self.request.user).order_by('seat_no')
            

            # transformed_dict = {hall.name: [] for hall in sorted_halls}
            # transformed_dict = {hall: [] for hall in sorted_halls}

            sorted_hall_caps = sorted(range(num_halls), key=lambda x: hall_cap[x])
            # sorted_halls = sorted(halls, key=lambda x: hall_cap[x])
            sorted_halls = sorted(halls, key=lambda hall: hall.seat_no)

            print(f"sort_cap: {sorted_hall_caps}")
            print(f"sort: {sorted_halls}")
            # seating_allocation = {hall.hall_id: [] for hall in halls}
            seating_allocation = {hall: [] for hall in sorted_halls}
            # seating_allocation = {hall: [] for hall in range(num_halls)}


            if num_students > sum(hall_cap):
                print("Shortage of seats number, get more seats")
                return None
            else:
                print(f"num std:{num_students}")
                print(f"hall sum:{sum(hall_cap)}")

                remaining_seats = {}

                for hall in sorted_halls:
                    seats = list(range(1, hall.seat_no + 1))
                    # print(f"seats- {seats}")
                    for _ in range(max_students_per_hall):
                        # seat_number = len(seating_allocation[hall]) + 1
                        if seats:
                            seating_allocation[hall].append([students.pop(0), seats.pop(0)])
                            print(f"seatAlloc: {seating_allocation}")
                            # print(f"seats_remains: {seats}")
                            remaining_seats[hall] = seats
                        else:
                            break

                

                # for hall in sorted_hall_caps:
                #     for _ in range(max_students_per_hall):
                #         seat_number = len(seating_allocation[hall]) + 1
                #         # seat_number = len(seating_allocation[hall]) + 1
                #         seating_allocation[hall].append([students.pop(0), seat_number])
                #         print(f"seatAlloc: {seating_allocation[hall]}")

                # print(f"seatsss: {seating_allocation[hall]}")
                # cal the remaining seat in each hall
                # remaining_seats = { hall: len(seating_allocation[hall])
                #                    for hall in sorted_halls }
                
                
                # remaining_seats = { hall: list(range(len(seating_allocation[hall]) + 1, hall_cap[hall.seat_no] + 1)) 
                #                    for hall in sorted_halls }
                

                # remaining_seats = { hall: list(range(len(seating_allocation[hall]) + 1, hall_cap[hall] + 1)) 
                #                    for hall in sorted_hall_caps }

                # print(f"remaining seats: {remaining_seats}")


                # Distribute any remaining students evenly across the halls
                for hall in sorted_halls:
                    print(f"len remaining seat: {len(remaining_seats[hall])}")
                    print(f"hall_cap: {hall.seat_no}")
                    print(f"remaining student: {remaining_students}")

                    while len(remaining_seats[hall]) < hall.seat_no and remaining_students > 0:
                        # seat_number = len(seating_allocation[hall]) + 1
                        seat_number = remaining_seats[hall.seats].pop(0)
                        seating_allocation[hall].append((students.pop(0), seat_number))
                        remaining_students -=1

                # for hall in sorted_hall_caps:
                #     while len(seating_allocation[hall]) < hall_cap[hall] and remaining_students > 0:
                #         # seat_number = len(seating_allocation[hall]) + 1
                #         seat_number = remaining_seats[hall].pop(0)
                #         seating_allocation[hall].append((students.pop(0), seat_number))
                #         remaining_students -=1


            # print(f"Halls: {hall_cap}")
            print(f"Shuffled Students: {students}")
            print(f"max_student_per_hall: {num_halls}")
            # print(f"sorted_hall: {sorted_halls}")
            # print(f"seating_allocation: {seating_allocation}")
            print(f"seating_allocation_dict: {seating_allocation}")

            seating_list = [[hall] + seat for hall, seats in seating_allocation.items() for seat in seats]
           

            # print(f"seating_list: {seating_list}")

'''
