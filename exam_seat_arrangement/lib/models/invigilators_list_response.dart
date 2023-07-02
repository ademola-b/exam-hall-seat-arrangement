// To parse this JSON data, do
//
//     final invigilatorsListResponse = invigilatorsListResponseFromJson(jsonString);

import 'dart:convert';

List<InvigilatorsListResponse> invigilatorsListResponseFromJson(String str) => List<InvigilatorsListResponse>.from(json.decode(str).map((x) => InvigilatorsListResponse.fromJson(x)));

String invigilatorsListResponseToJson(List<InvigilatorsListResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InvigilatorsListResponse {
    String profileId;
    UserId userId;
    String phone;

    InvigilatorsListResponse({
        required this.profileId,
        required this.userId,
        required this.phone,
    });

    factory InvigilatorsListResponse.fromJson(Map<String, dynamic> json) => InvigilatorsListResponse(
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
