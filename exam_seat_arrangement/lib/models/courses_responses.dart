// To parse this JSON data, do
//
//     final coursesResponse = coursesResponseFromJson(jsonString);

import 'dart:convert';

List<CoursesResponse> coursesResponseFromJson(String str) => List<CoursesResponse>.from(json.decode(str).map((x) => CoursesResponse.fromJson(x)));

String coursesResponseToJson(List<CoursesResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CoursesResponse {
    String courseId;
    String courseTitle;
    String courseDesc;
    String deptId;

    CoursesResponse({
        required this.courseId,
        required this.courseTitle,
        required this.courseDesc,
        required this.deptId,
    });

    factory CoursesResponse.fromJson(Map<String, dynamic> json) => CoursesResponse(
        courseId: json["course_id"],
        courseTitle: json["course_title"],
        courseDesc: json["course_desc"],
        deptId: json["dept_id"],
    );

    Map<String, dynamic> toJson() => {
        "course_id": courseId,
        "course_title": courseTitle,
        "course_desc": courseDesc,
        "dept_id": deptId,
    };
}
