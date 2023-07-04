// To parse this JSON data, do
//
//     final passwordChangeResponse = passwordChangeResponseFromJson(jsonString);

import 'dart:convert';

PasswordChangeResponse passwordChangeResponseFromJson(String str) => PasswordChangeResponse.fromJson(json.decode(str));

String passwordChangeResponseToJson(PasswordChangeResponse data) => json.encode(data.toJson());

class PasswordChangeResponse {
    List<String>? oldPassword;
    List<String>? newPassword1;
    List<String>? newPassword2;
    String? detail;

    PasswordChangeResponse({
        this.oldPassword,
        this.newPassword1,
        this.newPassword2,
        this.detail,
    });

    factory PasswordChangeResponse.fromJson(Map<String, dynamic> json) => PasswordChangeResponse(
        oldPassword: json["old_password"] == null ? [] : List<String>.from(json["old_password"]!.map((x) => x)),
        newPassword1: json["new_password1"] == null ? [] : List<String>.from(json["new_password1"]!.map((x) => x)),
        newPassword2: json["new_password2"] == null ? [] : List<String>.from(json["new_password2"]!.map((x) => x)),
        detail: json["detail"],
    );

    Map<String, dynamic> toJson() => {
        "old_password": oldPassword == null ? [] : List<dynamic>.from(oldPassword!.map((x) => x)),
        "new_password1": newPassword1 == null ? [] : List<dynamic>.from(newPassword1!.map((x) => x)),
        "new_password2": newPassword2 == null ? [] : List<dynamic>.from(newPassword2!.map((x) => x)),
        "detail": detail,
    };
}
