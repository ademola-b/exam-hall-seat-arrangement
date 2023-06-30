// To parse this JSON data, do
//
//     final seatArrangementResponse = seatArrangementResponseFromJson(jsonString);

import 'dart:convert';

List<SeatArrangementResponse> seatArrangementResponseFromJson(String str) => List<SeatArrangementResponse>.from(json.decode(str).map((x) => SeatArrangementResponse.fromJson(x)));

String seatArrangementResponseToJson(List<SeatArrangementResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SeatArrangementResponse {
    String seatArrangementId;
    AllocationId allocationId;
    StudentId studentId;
    int seatNo;

    SeatArrangementResponse({
        required this.seatArrangementId,
        required this.allocationId,
        required this.studentId,
        required this.seatNo,
    });

    factory SeatArrangementResponse.fromJson(Map<String, dynamic> json) => SeatArrangementResponse(
        seatArrangementId: json["seat_arrangement_id"],
        allocationId: AllocationId.fromJson(json["allocation_id"]),
        studentId: StudentId.fromJson(json["student_id"]),
        seatNo: json["seat_no"],
    );

    Map<String, dynamic> toJson() => {
        "seat_arrangement_id": seatArrangementId,
        "allocation_id": allocationId.toJson(),
        "student_id": studentId.toJson(),
        "seat_no": seatNo,
    };
}

class AllocationId {
    String allocationId;
    DateTime date;
    String course;
    HallId hallId;
    int noSeat;
    String level;
    String invigilator;

    AllocationId({
        required this.allocationId,
        required this.date,
        required this.course,
        required this.hallId,
        required this.noSeat,
        required this.level,
        required this.invigilator,
    });

    factory AllocationId.fromJson(Map<String, dynamic> json) => AllocationId(
        allocationId: json["allocation_id"],
        date: DateTime.parse(json["date"]),
        course: json["course"],
        hallId: HallId.fromJson(json["hall_id"]),
        noSeat: json["no_seat"],
        level: json["level"],
        invigilator: json["invigilator"],
    );

    Map<String, dynamic> toJson() => {
        "allocation_id": allocationId,
        "date": date.toIso8601String(),
        "course": course,
        "hall_id": hallId.toJson(),
        "no_seat": noSeat,
        "level": level,
        "invigilator": invigilator,
    };
}

class HallId {
    String hallId;
    String name;
    int seatNo;

    HallId({
        required this.hallId,
        required this.name,
        required this.seatNo,
    });

    factory HallId.fromJson(Map<String, dynamic> json) => HallId(
        hallId: json["hall_id"],
        name: json["name"],
        seatNo: json["seat_no"],
    );

    Map<String, dynamic> toJson() => {
        "hall_id": hallId,
        "name": name,
        "seat_no": seatNo,
    };
}

class StudentId {
    UserId userId;
    String level;

    StudentId({
        required this.userId,
        required this.level,
    });

    factory StudentId.fromJson(Map<String, dynamic> json) => StudentId(
        userId: UserId.fromJson(json["user_id"]),
        level: json["level"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId.toJson(),
        "level": level,
    };
}

class UserId {
    String pk;
    String name;
    String username;
    String deptId;
    bool isStaff;
    bool isExamofficer;
    bool isStudent;
    bool isInvigilator;

    UserId({
        required this.pk,
        required this.name,
        required this.username,
        required this.deptId,
        required this.isStaff,
        required this.isExamofficer,
        required this.isStudent,
        required this.isInvigilator,
    });

    factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        pk: json["pk"],
        name: json["name"],
        username: json["username"],
        deptId: json["dept_id"],
        isStaff: json["is_staff"],
        isExamofficer: json["is_examofficer"],
        isStudent: json["is_student"],
        isInvigilator: json["is_invigilator"],
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "name": name,
        "username": username,
        "dept_id": deptId,
        "is_staff": isStaff,
        "is_examofficer": isExamofficer,
        "is_student": isStudent,
        "is_invigilator": isInvigilator,
    };
}
