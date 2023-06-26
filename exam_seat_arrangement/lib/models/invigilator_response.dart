// To parse this JSON data, do
//
//     final invigilatorResponse = invigilatorResponseFromJson(jsonString);

import 'dart:convert';

List<InvigilatorResponse> invigilatorResponseFromJson(String str) => List<InvigilatorResponse>.from(json.decode(str).map((x) => InvigilatorResponse.fromJson(x)));

String invigilatorResponseToJson(List<InvigilatorResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InvigilatorResponse {
    UserId userId;
    String phone;

    InvigilatorResponse({
        required this.userId,
        required this.phone,
    });

    factory InvigilatorResponse.fromJson(Map<String, dynamic> json) => InvigilatorResponse(
        userId: UserId.fromJson(json["user_id"]),
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId.toJson(),
        "phone": phone,
    };
}

class UserId {
    String username;
    String name;

    UserId({
        required this.username,
        required this.name,
    });

    factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        username: json["username"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "name": name,
    };
}
