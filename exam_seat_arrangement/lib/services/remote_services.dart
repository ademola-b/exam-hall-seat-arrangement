import 'dart:convert';

import 'package:exam_seat_arrangement/main.dart';
import 'package:exam_seat_arrangement/models/create_hall_response.dart';
import 'package:exam_seat_arrangement/models/login_response.dart';
import 'package:exam_seat_arrangement/models/student_response.dart';
import 'package:exam_seat_arrangement/models/user_response.dart';
import 'package:exam_seat_arrangement/services/urls.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class RemoteServices {
  static Future<UserDetailsResponse?> userResponse(
      context, String? token) async {
    try {
      Response response =
          await http.get(userUrl, headers: {'Authorization': "Token $token"});
      if (response.statusCode == 200) {
        return userDetailsResponseFromJson(response.body);
      } else {
        throw Exception('Failed to get user details');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An Error Occurred: $e", false));
    }
  }

  static Future<LoginResponse?> login(
      context, String username, String password) async {
    try {
      Response response = await http
          .post(loginUrl, body: {'username': username, 'password': password});

      var responseData = jsonDecode(response.body);
      if (responseData != null) {
        if (responseData['key'] != null) {
          sharedPreferences.setString('token', responseData['key']);
          UserDetailsResponse? user_details =
              await RemoteServices.userResponse(context, responseData['key']);
          if (user_details != null) {
            if (user_details.isExamofficer) {
              Navigator.popAndPushNamed(context, '/examOfficerNavbar');
            } else if (user_details.isInvigilator || user_details.isStudent) {
              Navigator.popAndPushNamed(context, '/bottomNavbar');
            } else if (user_details.isStaff) {
              ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
                  context, "Page Still in Construction", true));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  Constants.snackBar(context, "Invalid User Type", false));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                Constants.snackBar(context, "No user found", false));
          }
        }

        if (responseData['non_field_errors'] != null) {
          for (var element in responseData["non_field_errors"]) {
            ScaffoldMessenger.of(context)
                .showSnackBar(Constants.snackBar(context, "$element", false));
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
  }

  static Future<AddHallResponse?> createHall(context,
      {String? name, String? seat_no, List<Map<String, dynamic>>? data}) async {
    // context, String? name, String seat_no, List<Map<String, dynamic>>data) async {
    try {
      Response response = await http.post(
        addHallUrl,
        body: jsonEncode(data),
        // body: jsonEncode([
        //   {'name': name, 'seat_no': seat_no}
        // ]),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${sharedPreferences.getString('token')}'
        },
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
            Constants.snackBar(context, "Hall Created Successfully", true));
        // Navigator.pop(context);
        // return addHallResponseFromJson(response.body);
      } else {
        var responseData = jsonDecode(response.body);
        for (var responses in responseData) {
          for (var element in responses.keys) {
            var value = responses[element];
            ScaffoldMessenger.of(context)
                .showSnackBar(Constants.snackBar(context, "$value", false));
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
    return null;
  }

  static Future<StudentResponse?> createStudent(context,
      {List<Map<String, dynamic>>? data}) async {
    try {
      Response response = await http.post(
        addStudentUrl,
        body: jsonEncode(data),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
            context, "Student(s) Account Created Successfully", true));
      } else {
        var responseData = jsonDecode(response.body);
        for (var responses in responseData) {
          for (var element in responses.keys) {
            var value = responses[element];
            ScaffoldMessenger.of(context)
                .showSnackBar(Constants.snackBar(context, "$value", false));
          }
        }

        // String output = '';
        // var responseData = jsonDecode(response.body);
        // responseData.forEach((key, value) {
        //   if (value is List) {
        //     List<dynamic> valueList = value;
        //     if (valueList.isNotEmpty) {
        //       String cleanValue = valueList[0]
        //           .toString()
        //           .replaceAll('[', '')
        //           .replaceAll(']', '');
        //       output += "$cleanValue\n";
        //     }
        //   }
        // });

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(Constants.snackBar(context, output, true));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
    return null;
  }
}
