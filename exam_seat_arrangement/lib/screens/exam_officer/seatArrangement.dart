import 'package:exam_seat_arrangement/models/courses_responses.dart';
import 'package:exam_seat_arrangement/models/create_hall_response.dart';
import 'package:exam_seat_arrangement/models/halls_response.dart';
import 'package:exam_seat_arrangement/services/remote_services.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultButton.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultDropDown.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SeatArrangement extends StatefulWidget {
  const SeatArrangement({super.key});

  @override
  State<SeatArrangement> createState() => _SeatArrangementState();
}

class _SeatArrangementState extends State<SeatArrangement> {
  Map hall_list = {};
  Map course_list = {};
  DateTime pickedDate = DateTime.now();
  TextEditingController _date = TextEditingController();
  final _form = GlobalKey<FormState>();
  var dropdownvalue;
  var dropdownvalue1;
  late String _hall, _course;

  _pickDate() async {
    DateTime? picked = await Constants.pickDate(context, pickedDate);
    if (picked != null && picked != pickedDate) {
      setState(() {
        pickedDate = picked;
        _date.text = DateFormat("yyyy-MM-dd").format(pickedDate);
        // print(formattedDate);
      });
    }
  }

  _getHall() async {
    List<HallsResponse>? halls = await RemoteServices.halls(context);
    if (halls!.isNotEmpty) {
      setState(() {
        for (var hall in halls) {
          hall_list[hall.hallId] = hall.name;
        }
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(Constants.snackBar(context, "No Hall", false));
    }
  }

  _getCourses() async {
    List<CoursesResponse?>? courses = await RemoteServices.courses(context);
    if (courses!.isNotEmpty) {
      setState(() {
        for (var course in courses) {
          course_list[course!.courseId] = course.courseDesc;
        }
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(Constants.snackBar(context, "No Course", false));
    }
  }

  _viewSeatArrangement() async {
    var isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();

    Navigator.pushNamed(context, '/seatArrangementView',
        arguments: {'date': _date.text, 'hall_id': _hall, 'course': _course});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getHall();
    _getCourses();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.splashBackColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios,
                          color: Constants.backgroundColor),
                      iconSize: 25,
                    ),
                    const DefaultText(
                      text: "SEAT ARRANGEMENT",
                      size: 20.0,
                      color: Constants.primaryColor,
                    )
                  ],
                ),
                const SizedBox(height: 40.0),
                const SizedBox(height: 70.0),
                Form(
                    key: _form,
                    child: Column(
                      children: [
                        DefaultTextFormField(
                          text: _date,
                          onTap: _pickDate,
                          obscureText: false,
                          fontSize: 20.0,
                          label: "Date",
                          icon: Icons.date_range,
                          fillColor: Colors.white,
                          keyboardInputType: TextInputType.none,
                          validator: Constants.validator,
                        ),
                        const SizedBox(height: 20.0),
                        DefaultDropDown(
                          onChanged: (newVal) {
                            setState(() {
                              dropdownvalue = newVal;
                            });
                          },
                          dropdownMenuItemList: course_list
                              .map((key, value) => MapEntry(
                                  key,
                                  DropdownMenuItem(
                                    value: key,
                                    child: DefaultText(
                                      text: value.toString(),
                                    ),
                                  )))
                              .values
                              .toList(),
                          value: dropdownvalue,
                          text: "Course",
                          onSaved: (newVal) {
                            _course = newVal;
                          },
                          validator: (value) {
                            if (value == null) {
                              return "field is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        DefaultDropDown(
                          onChanged: (newVal) {
                            setState(() {
                              dropdownvalue1 = newVal;
                            });
                          },
                          dropdownMenuItemList: hall_list
                              .map((key, value) => MapEntry(
                                  key,
                                  DropdownMenuItem(
                                    value: key,
                                    child: DefaultText(
                                      text: value.toString(),
                                    ),
                                  )))
                              .values
                              .toList(),
                          text: "Hall",
                          onSaved: (newVal) {
                            _hall = newVal;
                          },
                          validator: (value) {
                            if (value == null) {
                              return "field is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 70.0),
                        SizedBox(
                          width: size.width,
                          child: DefaultButton(
                              onPressed: () {
                                _viewSeatArrangement();
                                // Navigator.pushNamed(
                                //     context, '/seatArrangementView');
                              },
                              text: "View Seat Arrangement",
                              textSize: 20.0),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
