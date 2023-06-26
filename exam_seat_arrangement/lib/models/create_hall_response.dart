// To parse this JSON data, do
//
//     final addHallResponse = addHallResponseFromJson(jsonString);

import 'dart:convert';

AddHallResponse addHallResponseFromJson(String str) =>
    AddHallResponse.fromJson(json.decode(str));

String addHallResponseToJson(AddHallResponse data) =>
    json.encode(data.toJson());

class AddHallResponse {
  String hallId;
  String name;
  int seatNo;

  AddHallResponse({
    required this.hallId,
    required this.name,
    required this.seatNo,
  });

  factory AddHallResponse.fromJson(Map<String, dynamic> json) =>
      AddHallResponse(
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
