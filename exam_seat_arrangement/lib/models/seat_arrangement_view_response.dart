// // To parse this JSON data, do
// //
// //     final seatArrangementViewResponse = seatArrangementViewResponseFromJson(jsonString);

// import 'dart:convert';

// List<SeatArrangementViewResponse> seatArrangementViewResponseFromJson(
//         String str) =>
//     List<SeatArrangementViewResponse>.from(
//         json.decode(str).map((x) => SeatArrangementViewResponse.fromJson(x)));

// String seatArrangementViewResponseToJson(
//         List<SeatArrangementViewResponse> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class SeatArrangementViewResponse {
//   String? seatArrangementId;
//   AllocationId? allocationId;
//   HallId? hallId;
//   StudentId? studentId;
//   int? seatNo;

//   SeatArrangementViewResponse({
//     this.seatArrangementId,
//     this.allocationId,
//     this.hallId,
//     this.studentId,
//     this.seatNo,
//   });

//   factory SeatArrangementViewResponse.fromJson(Map<String, dynamic> json) =>
//       SeatArrangementViewResponse(
//         seatArrangementId: json["seat_arrangement_id"],
//         allocationId: json["allocation_id"] == null
//             ? null
//             : AllocationId.fromJson(json["allocation_id"]),
//         hallId:
//             json["hall_id"] == null ? null : HallId.fromJson(json["hall_id"]),
//         studentId: json["student_id"] == null
//             ? null
//             : StudentId.fromJson(json["student_id"]),
//         seatNo: json["seat_no"],
//       );

//   Map<String, dynamic> toJson() => {
//         "seat_arrangement_id": seatArrangementId,
//         "allocation_id": allocationId?.toJson(),
//         "hall_id": hallId?.toJson(),
//         "student_id": studentId?.toJson(),
//         "seat_no": seatNo,
//       };
// }

// class AllocationId {
//   String? allocationId;
//   DateTime? date;
//   String? level;
//   String? userId;
//   String? course;
//   String? invigilator;

//   AllocationId({
//     this.allocationId,
//     this.date,
//     this.level,
//     this.userId,
//     this.course,
//     this.invigilator,
//   });

//   factory AllocationId.fromJson(Map<String, dynamic> json) => AllocationId(
//         allocationId: json["allocation_id"],
//         date: json["date"] == null ? null : DateTime.parse(json["date"]),
//         level: json["level"],
//         userId: json["user_id"],
//         course: json["course"],
//         invigilator: json["invigilator"],
//       );

//   Map<String, dynamic> toJson() => {
//         "allocation_id": allocationId,
//         "date": date?.toIso8601String(),
//         "level": level,
//         "user_id": userId,
//         "course": course,
//         "invigilator": invigilator,
//       };
// }

// class HallId {
//   String? hallId;
//   String? name;
//   int? seatNo;

//   HallId({
//     this.hallId,
//     this.name,
//     this.seatNo,
//   });

//   factory HallId.fromJson(Map<String, dynamic> json) => HallId(
//         hallId: json["hall_id"],
//         name: json["name"],
//         seatNo: json["seat_no"],
//       );

//   Map<String, dynamic> toJson() => {
//         "hall_id": hallId,
//         "name": name,
//         "seat_no": seatNo,
//       };
// }

// class StudentId {
//   UserId? userId;
//   String? level;

//   StudentId({
//     this.userId,
//     this.level,
//   });

//   factory StudentId.fromJson(Map<String, dynamic> json) => StudentId(
//         userId:
//             json["user_id"] == null ? null : UserId.fromJson(json["user_id"]),
//         level: json["level"],
//       );

//   Map<String, dynamic> toJson() => {
//         "user_id": userId?.toJson(),
//         "level": level,
//       };
// }

// class UserId {
//   String? pk;
//   String? name;
//   String? username;
//   String? deptId;
//   bool? isStaff;
//   bool? isExamofficer;
//   bool? isStudent;
//   bool? isInvigilator;

//   UserId({
//     this.pk,
//     this.name,
//     this.username,
//     this.deptId,
//     this.isStaff,
//     this.isExamofficer,
//     this.isStudent,
//     this.isInvigilator,
//   });

//   factory UserId.fromJson(Map<String, dynamic> json) => UserId(
//         pk: json["pk"],
//         name: json["name"],
//         username: json["username"],
//         deptId: json["dept_id"],
//         isStaff: json["is_staff"],
//         isExamofficer: json["is_examofficer"],
//         isStudent: json["is_student"],
//         isInvigilator: json["is_invigilator"],
//       );

//   Map<String, dynamic> toJson() => {
//         "pk": pk,
//         "name": name,
//         "username": username,
//         "dept_id": deptId,
//         "is_staff": isStaff,
//         "is_examofficer": isExamofficer,
//         "is_student": isStudent,
//         "is_invigilator": isInvigilator,
//       };
// }


// To parse this JSON data, do
//
//     final seatArrangementViewResponse = seatArrangementViewResponseFromJson(jsonString);

import 'dart:convert';

List<SeatArrangementViewResponse> seatArrangementViewResponseFromJson(String str) => List<SeatArrangementViewResponse>.from(json.decode(str).map((x) => SeatArrangementViewResponse.fromJson(x)));

String seatArrangementViewResponseToJson(List<SeatArrangementViewResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SeatArrangementViewResponse {
    String? seatArrangementId;
    AllocationId? allocationId;
    HallId? hallId;
    StudentId? studentId;
    int? seatNo;

    SeatArrangementViewResponse({
        this.seatArrangementId,
        this.allocationId,
        this.hallId,
        this.studentId,
        this.seatNo,
    });

    factory SeatArrangementViewResponse.fromJson(Map<String, dynamic> json) => SeatArrangementViewResponse(
        seatArrangementId: json["seat_arrangement_id"],
        allocationId: json["allocation_id"] == null ? null : AllocationId.fromJson(json["allocation_id"]),
        hallId: json["hall_id"] == null ? null : HallId.fromJson(json["hall_id"]),
        studentId: json["student_id"] == null ? null : StudentId.fromJson(json["student_id"]),
        seatNo: json["seat_no"],
    );

    Map<String, dynamic> toJson() => {
        "seat_arrangement_id": seatArrangementId,
        "allocation_id": allocationId?.toJson(),
        "hall_id": hallId?.toJson(),
        "student_id": studentId?.toJson(),
        "seat_no": seatNo,
    };
}

class AllocationId {
    String? userId;
    String? allocationId;
    DateTime? date;
    Course? course;
    String? level;
    Invigilator? invigilator;

    AllocationId({
        this.userId,
        this.allocationId,
        this.date,
        this.course,
        this.level,
        this.invigilator,
    });

    factory AllocationId.fromJson(Map<String, dynamic> json) => AllocationId(
        userId: json["user_id"],
        allocationId: json["allocation_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        course: json["course"] == null ? null : Course.fromJson(json["course"]),
        level: json["level"],
        invigilator: json["invigilator"] == null ? null : Invigilator.fromJson(json["invigilator"]),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "allocation_id": allocationId,
        "date": date?.toIso8601String(),
        "course": course?.toJson(),
        "level": level,
        "invigilator": invigilator?.toJson(),
    };
}

class Course {
    String? courseId;
    String? deptId;
    String? courseTitle;
    String? courseDesc;

    Course({
        this.courseId,
        this.deptId,
        this.courseTitle,
        this.courseDesc,
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
    String? profileId;
    UserId? userId;
    String? phone;

    Invigilator({
        this.profileId,
        this.userId,
        this.phone,
    });

    factory Invigilator.fromJson(Map<String, dynamic> json) => Invigilator(
        profileId: json["profile_id"],
        userId: json["user_id"] == null ? null : UserId.fromJson(json["user_id"]),
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "profile_id": profileId,
        "user_id": userId?.toJson(),
        "phone": phone,
    };
}

class UserId {
    String? pk;
    String? name;
    String? username;
    String? deptId;
    bool? isStaff;
    bool? isExamofficer;
    bool? isStudent;
    bool? isInvigilator;

    UserId({
        this.pk,
        this.name,
        this.username,
        this.deptId,
        this.isStaff,
        this.isExamofficer,
        this.isStudent,
        this.isInvigilator,
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

class HallId {
    String? hallId;
    String? name;
    int? seatNo;

    HallId({
        this.hallId,
        this.name,
        this.seatNo,
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
    UserId? userId;
    String? level;

    StudentId({
        this.userId,
        this.level,
    });

    factory StudentId.fromJson(Map<String, dynamic> json) => StudentId(
        userId: json["user_id"] == null ? null : UserId.fromJson(json["user_id"]),
        level: json["level"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId?.toJson(),
        "level": level,
    };
}
