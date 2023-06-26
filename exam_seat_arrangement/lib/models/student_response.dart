// To parse this JSON data, do
//
//     final studentResponse = studentResponseFromJson(jsonString);

import 'dart:convert';

List<StudentResponse> studentResponseFromJson(String str) =>
    List<StudentResponse>.from(
        json.decode(str).map((x) => StudentResponse.fromJson(x)));

String studentResponseToJson(List<StudentResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentResponse {
  UserId? userId;
  int level;

  StudentResponse({
    this.userId,
    required this.level,
  });

  factory StudentResponse.fromJson(Map<String, dynamic> json) =>
      StudentResponse(
        userId: UserId.fromJson(json["user_id"]),
        level: json["level"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId!.toJson(),
        "level": level,
      };
}

class UserId {
  String username;
  String name;
  String deptId;

  UserId({
    required this.username,
    required this.name,
    required this.deptId,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        username: json["username"],
        name: json["name"],
        deptId: json["dept_id"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "name": name,
        "dept_id": deptId,
      };
}
