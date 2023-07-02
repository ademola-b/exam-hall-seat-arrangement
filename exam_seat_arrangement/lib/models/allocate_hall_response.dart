// To parse this JSON data, do
//
//     final allocateHallResponse = allocateHallResponseFromJson(jsonString);

import 'dart:convert';

AllocateHallResponse allocateHallResponseFromJson(String str) => AllocateHallResponse.fromJson(json.decode(str));

String allocateHallResponseToJson(AllocateHallResponse data) => json.encode(data.toJson());

class AllocateHallResponse {
    DateTime date;
    String level;
    String course;
    String invigilator;

    AllocateHallResponse({
        required this.date,
        required this.level,
        required this.course,
        required this.invigilator,
    });

    factory AllocateHallResponse.fromJson(Map<String, dynamic> json) => AllocateHallResponse(
        date: DateTime.parse(json["date"]),
        level: json["level"],
        course: json["course"],
        invigilator: json["invigilator"],
    );

    Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "level": level,
        "course": course,
        "invigilator": invigilator,
    };
}
