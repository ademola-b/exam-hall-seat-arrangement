import 'dart:convert';

import 'package:exam_seat_arrangement/main.dart';
import 'package:exam_seat_arrangement/models/allocate_hall_response.dart';
import 'package:exam_seat_arrangement/models/allocations_response.dart';
import 'package:exam_seat_arrangement/models/courses_responses.dart';
import 'package:exam_seat_arrangement/models/create_hall_response.dart';
import 'package:exam_seat_arrangement/models/halls_response.dart';
import 'package:exam_seat_arrangement/models/invigilator_response.dart';
import 'package:exam_seat_arrangement/models/invigilators_list_response.dart';
import 'package:exam_seat_arrangement/models/login_response.dart';
import 'package:exam_seat_arrangement/models/password_change_response.dart';
import 'package:exam_seat_arrangement/models/seat_arrangement_response.dart';
import 'package:exam_seat_arrangement/models/student_response.dart';
import 'package:exam_seat_arrangement/models/user_response.dart';
import 'package:exam_seat_arrangement/services/urls.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class RemoteServices {
  static Future<UserDetailsResponse?> userResponse(context) async {
    try {
      Response response = await http.get(userUrl, headers: {
        'Authorization': "Token ${sharedPreferences.getString('token')}"
      });
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
      var response = await http
          .post(loginUrl, body: {'username': username, 'password': password});

      var responseData = jsonDecode(response.body);
      if (responseData != null) {
        if (responseData['key'] != null) {
          sharedPreferences.setString('token', responseData['key']);
          UserDetailsResponse? user_details =
              await RemoteServices.userResponse(context);
          if (user_details != null) {
            if (user_details.isExamofficer) {
              sharedPreferences.setString(
                  "examOfficerDept", user_details.deptId);
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

  // static Future<List<HallsResponse>?>? halls(context) {

  //   return null;
  // }

  static Future<AddHallResponse?> createHall(context,
      {String? name, String? seat_no, List<Map<String, dynamic>>? data}) async {
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
            Constants.snackBar(context, "Hall(s) Created Successfully", true));
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

  static Future<List<InvigilatorsListResponse>?>? invigilatorList(
      context) async {
    try {
      Response response =
          await http.get(invigilatorUrl, headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8',
        "Authorization": "Token ${sharedPreferences.getString('token')}"
      });
      if (response.statusCode == 200) {
        return invigilatorsListResponseFromJson(response.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
  }

  static Future<InvigilatorResponse?> createInvigilator(context,
      {List<Map<String, dynamic>>? data}) async {
    try {
      Response response = await http.post(
        invigilatorUrl,
        body: jsonEncode(data),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
            context, "Invigilator(s) Account Created Successfully", true));
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

  static Future<List<SeatArrangementResponse?>?> viewSeatArrangement(
      context, String? date) async {
    try {
      Response response = await http.get(
          Uri.parse("$baseUrl/api/exam-seat/seat-arrangement/$date/"),
          headers: <String, String>{
            'content-type': 'application/json; charset=UTF-8',
            'Authorization': "Token ${sharedPreferences.getString("token")}"
          });
      if (response.statusCode == 200) {
        return seatArrangementResponseFromJson(response.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
    return [];
  }

  static Future<List<SeatArrangementResponse>?>? seatArrangementForExamOfficer(
      context, String? date, String? hall_id, String course_id) async {
    try {
      Response response = await http.get(
          Uri.parse(
              "$baseUrl/api/exam-seat/seat-arrangement/$date/$hall_id/$course_id/"),
          headers: <String, String>{
            'content-type': 'application/json; charset=UTF-8',
            'Authorization': "Token ${sharedPreferences.getString("token")}"
          });
      if (response.statusCode == 200) {
        return seatArrangementResponseFromJson(response.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }

    return null;
  }

  static Future<List<HallsResponse>?>? halls(context) async {
    try {
      Response response = await http.get(hallsUrl, headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8',
        "Authorization": "Token ${sharedPreferences.getString("token")}"
      });
      if (response.statusCode == 200) {
        return hallsResponseFromJson(response.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
    return [];
  }

  static Future<List<HallsResponse>?>? hallsWithId(context, String id) async {
    try {
      Response response = await http.get(
          Uri.parse("$baseUrl/api/exam-seat/halls/$id/"),
          headers: <String, String>{
            'content-type': 'application/json; charset=UTF-8',
            "Authorization": "Token ${sharedPreferences.getString("token")}"
          });
      if (response.statusCode == 200) {
        return hallsResponseFromJson(response.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
    return [];
  }

  static Future<void> deleteHall(context, String? id) async {
    try {
      Response response = await http
          .delete(Uri.parse("$baseUrl/api/exam-seat/hall/delete/$id/"));
      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
            Constants.snackBar(context, "Hall Successfully Deleted", false));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
  }

  static Future<List<CoursesResponse>?>? courses(context) async {
    try {
      Response response = await http.get(coursesUrl);
      if (response.statusCode == 200) {
        return coursesResponseFromJson(response.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
    return [];
  }

  static Future<List<CoursesResponse>?>? courseWithId(
      context, String id) async {
    try {
      Response response =
          await http.get(Uri.parse("$baseUrl/api/exam-seat/courses/$id/"));
      if (response.statusCode == 200) {
        return coursesResponseFromJson(response.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
    return [];
  }

  static Future<AllocateHallResponse?>? allocateHall(context, String? date,
      String? level, String? course, String? invigilator) async {
    try {
      Response response = await http.post(allocateHallUrl,
          body: jsonEncode({
            'date': date,
            'level': level,
            'course': course,
            'invigilator': invigilator
          }),
          headers: <String, String>{
            'content-type': 'application/json; charset=UTF-8',
            "Authorization": "Token ${sharedPreferences.getString('token')}"
          });
      if (response.statusCode == 201) {
        return allocateHallResponseFromJson(response.body);
      } else {
        var responseData = jsonDecode(response.body);
        print(responseData);
        if (responseData['exists'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              Constants.snackBar(context, "${responseData['exists']}", false));
        } else if (responseData['zero_max'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
              context, "${responseData['zero_max']}", false));
        } else if (responseData['empty_hall'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
              context, "${responseData['empty_hall']}", false));
        } else if (responseData['hall_shortage'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
              context, "${responseData['hall_shortage']}", false));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
    return null;
  }

  static Future<List<AllocationsResponse>?>? allocations(context,
      {String? date}) async {
    try {
      if (date == null) {
        Response response =
            await http.get(allocationsUrl, headers: <String, String>{
          "content-type": "application/json; charset=UTF-8",
          "Authorization": "Token ${sharedPreferences.getString('token')}"
        });
        if (response.statusCode == 200) {
          return allocationsResponseFromJson(response.body);
        }
      } else {
        Response response = await http.get(
            Uri.parse("$baseUrl/api/exam-seat/allocations/$date/"),
            headers: <String, String>{
              "content-type": "application/json; charset=UTF-8",
              "Authorization": "Token ${sharedPreferences.getString('token')}"
            });
        if (response.statusCode == 200) {
          return allocationsResponseFromJson(response.body);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }

    return null;
  }

  static Future<void> deleteAllocation(context, String? id) async {
    try {
      Response response = await http
          .delete(Uri.parse("$baseUrl/api/exam-seat/allocations/modify/$id/"));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['delete'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              Constants.snackBar(context, "${responseData['delete']}", false));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
  }

  static Future<PasswordChangeResponse?> passwordChange(
      context, String? oldPass, String? newPass, String? conPass) async {
    try {
      Response response = await http.post(passwordChangeUrl,
          headers: <String, String>{
            "content-type": "application/json; charset=UTF-8",
            "Authorization": "Token ${sharedPreferences.getString('token')}"
          },
          body: jsonEncode({
            'old_password': oldPass,
            'new_password1': newPass,
            'new_password2': conPass,
          }));
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['detail'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              Constants.snackBar(context, "${responseData['detail']}", true));
        }
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        if (responseData['new_password1'] != null) {
          String output = '';
          for (var element in responseData['new_password1']) {
            output += element + "\n";
          }
          ScaffoldMessenger.of(context)
              .showSnackBar(Constants.snackBar(context, output, false));
        } else if (responseData['new_password2'] != null) {
          String output = '';
          for (var element in responseData['new_password2']) {
            output += element + "\n";
          }
          ScaffoldMessenger.of(context)
              .showSnackBar(Constants.snackBar(context, output, false));
        } else if (responseData['old_password'] != null) {
          String output = '';
          for (var element in responseData['old_password']) {
            output += element + "\n";
          }
          ScaffoldMessenger.of(context)
              .showSnackBar(Constants.snackBar(context, output, false));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", true));
    }

    return null;
  }
}
