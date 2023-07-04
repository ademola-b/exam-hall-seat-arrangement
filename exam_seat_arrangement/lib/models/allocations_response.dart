// To parse this JSON data, do
//
//     final allocationsResponse = allocationsResponseFromJson(jsonString);

import 'dart:convert';

List<AllocationsResponse> allocationsResponseFromJson(String str) => List<AllocationsResponse>.from(json.decode(str).map((x) => AllocationsResponse.fromJson(x)));

String allocationsResponseToJson(List<AllocationsResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllocationsResponse {
    String userId;
    String allocationId;
    DateTime date;
    Course course;
    String level;
    Invigilator invigilator;

    AllocationsResponse({
        required this.userId,
        required this.allocationId,
        required this.date,
        required this.course,
        required this.level,
        required this.invigilator,
    });

    factory AllocationsResponse.fromJson(Map<String, dynamic> json) => AllocationsResponse(
        userId: json["user_id"],
        allocationId: json["allocation_id"],
        date: DateTime.parse(json["date"]),
        course: Course.fromJson(json["course"]),
        level: json["level"],
        invigilator: Invigilator.fromJson(json["invigilator"]),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "allocation_id": allocationId,
        "date": date.toIso8601String(),
        "course": course.toJson(),
        "level": level,
        "invigilator": invigilator.toJson(),
    };
}

class Course {
    String courseId;
    String deptId;
    String courseTitle;
    String courseDesc;

    Course({
        required this.courseId,
        required this.deptId,
        required this.courseTitle,
        required this.courseDesc,
    });

    factory Course.fromJson(Map<String, dynamic> json) => Course(
        courseId: json["course_id"],
        deptId: json["dept_id"],
        courseTitle: json["course_title"],
        courseDesc: json["course_desc"],
    );

    Map<String, dynamic> toJson() => {
        "course_id": courseId,
        "dept_id": deptId,
        "course_title": courseTitle,
        "course_desc": courseDesc,
    };
}

class Invigilator {
    String profileId;
    UserId userId;
    String phone;

    Invigilator({
        required this.profileId,
        required this.userId,
        required this.phone,
    });

    factory Invigilator.fromJson(Map<String, dynamic> json) => Invigilator(
        profileId: json["profile_id"],
        userId: UserId.fromJson(json["user_id"]),
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "profile_id": profileId,
        "user_id": userId.toJson(),
        "phone": phone,
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
