import random

def allocate_students_to_halls(num_students, num_halls, hall_capacities):
    # Calculate the maximum number of students per hall
    max_students_per_hall = num_students // num_halls
    remaining_students = num_students % num_halls

    # Sort the halls based on their capacity
    sorted_halls = sorted(range(num_halls), key=lambda x: hall_capacities[x])

    # Initialize the seating allocation dictionary
    seating_allocation = {hall: [] for hall in range(num_halls)}

    # Initialize student ID list
    student_ids = list(range(1, num_students + 1))
    random.shuffle(student_ids)  # Randomize the student IDs

    # Allocate the maximum number of students to each hall
    for hall in sorted_halls:
        for _ in range(max_students_per_hall):
            if student_ids:
                student_id = student_ids.pop(0)
                seating_allocation[hall].append((student_id, len(seating_allocation[hall]) + 1))
            else:
                break

    # Allocate remaining students while considering hall capacities
    hall_index = 0
    for _ in range(remaining_students):
        while len(seating_allocation[sorted_halls[hall_index]]) >= hall_capacities[sorted_halls[hall_index]]:
            hall_index = (hall_index + 1) % num_halls
        if student_ids:
            student_id = student_ids.pop(0)
            seating_allocation[sorted_halls[hall_index]].append((student_id, len(seating_allocation[sorted_halls[hall_index]]) + 1))
            hall_index = (hall_index + 1) % num_halls
        else:
            break

    return seating_allocation

# Example usage
num_students = 25
num_halls = 4
hall_capacities = [10, 10, 10, 10]  # Capacity of each hall

seating_allocation = allocate_students_to_halls(num_students, num_halls, hall_capacities)

# Print the seating allocation for each hall
for hall, students in seating_allocation.items():
    print(f"Hall {hall + 1}:")
    for student_id, seat_number in students:
        print(f"Student {student_id}: Seat {seat_number}")
    print()
