// To parse this JSON data, do
//
//     final hallsResponse = hallsResponseFromJson(jsonString);

import 'dart:convert';

List<HallsResponse> hallsResponseFromJson(String str) => List<HallsResponse>.from(json.decode(str).map((x) => HallsResponse.fromJson(x)));

String hallsResponseToJson(List<HallsResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HallsResponse {
    String hallId;
    String name;
    int seatNo;

    HallsResponse({
        required this.hallId,
        required this.name,
        required this.seatNo,
    });

    factory HallsResponse.fromJson(Map<String, dynamic> json) => HallsResponse(
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
