def allocate_seats(students, halls):
    num_students = len(students)
    num_halls = len(halls)
    hall_capacity = sum(halls.values())
    
    if num_students > hall_capacity:
        print("Insufficient seating capacity in halls.")
        return
    
    # Calculate the minimum number of students per hall
    min_students_per_hall = num_students // num_halls
    
    # Allocate the minimum number of students per hall
    for hall in halls:
        halls[hall] = min_students_per_hall
    
    remaining_students = num_students % num_halls
    
    # Allocate remaining students evenly across halls
    hall_index = 0
    while remaining_students > 0:
        hall = list(halls.keys())[hall_index]
        halls[hall] += 1
        remaining_students -= 1
        hall_index = (hall_index + 1) % num_halls
    
    # Print the allocation result
    for hall in halls:
        print(f"Hall {hall} - {halls[hall]} students")
        

# Example usage
students = ['Student1', 'Student2', 'Student3', 'Student4', 'Student5', 'Student6', 'Student7', 'Student8', 'Student9', 'Student10']
halls = {'Hall1': 3, 'Hall2': 4, 'Hall3': 3}

allocate_seats(students, halls)
