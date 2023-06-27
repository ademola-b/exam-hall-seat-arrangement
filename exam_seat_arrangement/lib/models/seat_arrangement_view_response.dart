// To parse this JSON data, do
//
//     final seatArrangementViewResponse = seatArrangementViewResponseFromJson(jsonString);

import 'dart:convert';

List<SeatArrangementViewResponse> seatArrangementViewResponseFromJson(String str) => List<SeatArrangementViewResponse>.from(json.decode(str).map((x) => SeatArrangementViewResponse.fromJson(x)));

String seatArrangementViewResponseToJson(List<SeatArrangementViewResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SeatArrangementViewResponse {
    String seatArrangementId;
    AllocationId allocationId;
    String studentId;
    int seatNo;

    SeatArrangementViewResponse({
        required this.seatArrangementId,
        required this.allocationId,
        required this.studentId,
        required this.seatNo,
    });

    factory SeatArrangementViewResponse.fromJson(Map<String, dynamic> json) => SeatArrangementViewResponse(
        seatArrangementId: json["seat_arrangement_id"],
        allocationId: AllocationId.fromJson(json["allocation_id"]),
        studentId: json["student_id"],
        seatNo: json["seat_no"],
    );

    Map<String, dynamic> toJson() => {
        "seat_arrangement_id": seatArrangementId,
        "allocation_id": allocationId.toJson(),
        "student_id": studentId,
        "seat_no": seatNo,
    };
}

class AllocationId {
    String allocationId;
    DateTime date;
    String semester;
    HallId hallId;
    int noSeat;
    String level;
    String invigilator;

    AllocationId({
        required this.allocationId,
        required this.date,
        required this.semester,
        required this.hallId,
        required this.noSeat,
        required this.level,
        required this.invigilator,
    });

    factory AllocationId.fromJson(Map<String, dynamic> json) => AllocationId(
        allocationId: json["allocation_id"],
        date: DateTime.parse(json["date"]),
        semester: json["semester"],
        hallId: HallId.fromJson(json["hall_id"]),
        noSeat: json["no_seat"],
        level: json["level"],
        invigilator: json["invigilator"],
    );

    Map<String, dynamic> toJson() => {
        "allocation_id": allocationId,
        "date": date.toIso8601String(),
        "semester": semester,
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
