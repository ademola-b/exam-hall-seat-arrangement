// To parse this JSON data, do
//
//     final userDetailsResponse = userDetailsResponseFromJson(jsonString);

import 'dart:convert';

UserDetailsResponse userDetailsResponseFromJson(String str) => UserDetailsResponse.fromJson(json.decode(str));

String userDetailsResponseToJson(UserDetailsResponse data) => json.encode(data.toJson());

class UserDetailsResponse {
    String pk;
    String username;
    String name;
    String deptId;
    bool isStaff;
    bool isExamofficer;
    bool isStudent;
    bool isInvigilator;

    UserDetailsResponse({
        required this.pk,
        required this.username,
        required this.name,
        required this.deptId,
        required this.isStaff,
        required this.isExamofficer,
        required this.isStudent,
        required this.isInvigilator,
    });

    factory UserDetailsResponse.fromJson(Map<String, dynamic> json) => UserDetailsResponse(
        pk: json["pk"],
        username: json["username"],
        name: json["name"],
        deptId: json["dept_id"],
        isStaff: json["is_staff"],
        isExamofficer: json["is_examofficer"],
        isStudent: json["is_student"],
        isInvigilator: json["is_invigilator"],
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "username": username,
        "name": name,
        "dept_id": deptId,
        "is_staff": isStaff,
        "is_examofficer": isExamofficer,
        "is_student": isStudent,
        "is_invigilator": isInvigilator,
    };
}

// // To parse this JSON data, do
// //
// //     final userDetailsResponse = userDetailsResponseFromJson(jsonString);

// import 'dart:convert';

// UserDetailsResponse userDetailsResponseFromJson(String str) => UserDetailsResponse.fromJson(json.decode(str));

// String userDetailsResponseToJson(UserDetailsResponse data) => json.encode(data.toJson());

// class UserDetailsResponse {
//     String pk;
//     String name;
//     String username;
//     DeptId deptId;
//     bool isStaff;
//     bool isExamofficer;
//     bool isStudent;
//     bool isInvigilator;

//     UserDetailsResponse({
//         required this.pk,
//         required this.name,
//         required this.username,
//         required this.deptId,
//         required this.isStaff,
//         required this.isExamofficer,
//         required this.isStudent,
//         required this.isInvigilator,
//     });

//     factory UserDetailsResponse.fromJson(Map<String, dynamic> json) => UserDetailsResponse(
//         pk: json["pk"],
//         name: json["name"],
//         username: json["username"],
//         deptId: DeptId.fromJson(json["dept_id"]),
//         isStaff: json["is_staff"],
//         isExamofficer: json["is_examofficer"],
//         isStudent: json["is_student"],
//         isInvigilator: json["is_invigilator"],
//     );

//     Map<String, dynamic> toJson() => {
//         "pk": pk,
//         "name": name,
//         "username": username,
//         "dept_id": deptId.toJson(),
//         "is_staff": isStaff,
//         "is_examofficer": isExamofficer,
//         "is_student": isStudent,
//         "is_invigilator": isInvigilator,
//     };
// }

// class DeptId {
//     String deptId;
//     String deptName;

//     DeptId({
//         required this.deptId,
//         required this.deptName,
//     });

//     factory DeptId.fromJson(Map<String, dynamic> json) => DeptId(
//         deptId: json["dept_id"],
//         deptName: json["dept_name"],
//     );

//     Map<String, dynamic> toJson() => {
//         "dept_id": deptId,
//         "dept_name": deptName,
//     };
// }

