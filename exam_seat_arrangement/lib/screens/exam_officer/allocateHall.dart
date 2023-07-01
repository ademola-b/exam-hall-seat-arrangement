import 'package:exam_seat_arrangement/models/courses_responses.dart';
import 'package:exam_seat_arrangement/models/halls_response.dart';
import 'package:exam_seat_arrangement/models/invigilators_list_response.dart';
import 'package:exam_seat_arrangement/services/remote_services.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultButton.dart';
import 'package:exam_seat_arrangement/utils/defaultDropDown.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllocateHall extends StatefulWidget {
  const AllocateHall({super.key});

  @override
  State<AllocateHall> createState() => _AllocateHallState();
}

class _AllocateHallState extends State<AllocateHall> {
  Map hall_list = {};
  Map course_list = {};
  Map level = {'1': 'ND I', '2': 'ND II', '3': 'HND I', '4': 'HND II'};
  Map invigilator_list = {};
  DateTime pickedDate = DateTime.now();
  TextEditingController _date = TextEditingController();
  var dropdownvalue;
  var dropdownvalue1;
  late String _hall, _course, _level, _invigilator;
  final _form = GlobalKey<FormState>();

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

  _getInvigilator() async {
    List<InvigilatorsListResponse?>? invigilators =
        await RemoteServices.invigilatorList(context);
    if (invigilators!.isNotEmpty) {
      for (var inv in invigilators) {
        invigilator_list[inv!.userId.pk] =
            "${inv.userId.username} - ${inv.userId.name}";
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
          context, "No Invigilator in your department", false));
    }
  }

  allocateHall() {
    var isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getHall();
    _getCourses();
    _getInvigilator();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.splashBackColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
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
                      iconSize: 30,
                    ),
                    const DefaultText(
                      text: "Allocate Hall",
                      size: 25.0,
                      color: Constants.primaryColor,
                    )
                  ],
                ),
                const SizedBox(height: 70.0),
                Form(
                    key: _form,
                    child: Column(
                      children: [
                        DefaultTextFormField(
                          text: _date,
                          obscureText: false,
                          fontSize: 20.0,
                          label: "Date",
                          onTap: _pickDate,
                          keyboardInputType: TextInputType.none,
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
                        // DefaultDropDown(
                        //   onChanged: (newVal) {
                        //     dropdownvalue1 = newVal;
                        //   },
                        //   dropdownMenuItemList: hall_list
                        //       .map((key, value) => MapEntry(
                        //           key,
                        //           DropdownMenuItem(
                        //             value: key,
                        //             child: DefaultText(
                        //               text: value.toString(),
                        //             ),
                        //           )))
                        //       .values
                        //       .toList(),
                        //   text: "Hall",
                        //   onSaved: (newVal) {
                        //     _hall = newVal;
                        //   },
                        //   validator: (value) {
                        //     if (value == null) {
                        //       return "field is required";
                        //     }
                        //     return null;
                        //   },
                        // ),
                        // const SizedBox(height: 20.0),
                        // const DefaultTextFormField(
                        //   obscureText: false,
                        //   fontSize: 20.0,
                        //   label: "No. of Seats",
                        //   keyboardInputType: TextInputType.number,
                        // ),
                        // const SizedBox(height: 20.0),
                        DefaultDropDown(
                          onChanged: (newVal) {
                            setState(() {
                              dropdownvalue = newVal;
                            });
                          },
                          dropdownMenuItemList: level
                              .map((key, value) => MapEntry(
                                  key,
                                  DropdownMenuItem(
                                      value: key,
                                      child:
                                          DefaultText(text: value.toString()))))
                              .values
                              .toList(),
                          text: "Level",
                          onSaved: (newVal) {
                            _level = newVal;
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
                            dropdownvalue = newVal;
                          },
                          dropdownMenuItemList: invigilator_list
                              .map((key, value) => MapEntry(
                                  key,
                                  DropdownMenuItem(
                                      value: key,
                                      child:
                                          DefaultText(text: value.toString()))))
                              .values
                              .toList(),
                          text: "Invigilator",
                          onSaved: (newVal) {
                            _invigilator = newVal;
                          },
                          validator: (value) {
                            if (value == null) {
                              return "field is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 50.0),
                        SizedBox(
                          width: size.width,
                          child: DefaultButton(
                              onPressed: () {
                                allocateHall();
                              },
                              text: "Allocate Hall",
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
