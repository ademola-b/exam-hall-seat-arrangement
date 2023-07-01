// To parse this JSON data, do
//
//     final allocateHallResponse = allocateHallResponseFromJson(jsonString);

import 'dart:convert';

AllocateHallResponse allocateHallResponseFromJson(String str) => AllocateHallResponse.fromJson(json.decode(str));

String allocateHallResponseToJson(AllocateHallResponse data) => json.encode(data.toJson());

class AllocateHallResponse {
    String allocationId;
    DateTime date;
    int noSeat;
    String level;
    String course;
    String hallId;
    String invigilator;

    AllocateHallResponse({
        required this.allocationId,
        required this.date,
        required this.noSeat,
        required this.level,
        required this.course,
        required this.hallId,
        required this.invigilator,
    });

    factory AllocateHallResponse.fromJson(Map<String, dynamic> json) => AllocateHallResponse(
        allocationId: json["allocation_id"],
        date: DateTime.parse(json["date"]),
        noSeat: json["no_seat"],
        level: json["level"],
        course: json["course"],
        hallId: json["hall_id"],
        invigilator: json["invigilator"],
    );

    Map<String, dynamic> toJson() => {
        "allocation_id": allocationId,
        "date": date.toIso8601String(),
        "no_seat": noSeat,
        "level": level,
        "course": course,
        "hall_id": hallId,
        "invigilator": invigilator,
    };
}
