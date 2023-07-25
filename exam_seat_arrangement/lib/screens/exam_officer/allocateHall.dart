import 'package:exam_seat_arrangement/models/allocate_hall_response.dart';
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
  DateTime dateTime = DateTime.now();
  var dateTimeConv, pickedDateTime;

  AllocateHallResponse? _allocateHall;

  _pickDateTime() async {
    DateTime? pickedDate = await Constants.pickDate(context, dateTime);
    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await Constants.pickTime(context, dateTime);
    if (pickedTime == null) return;

    dateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
        pickedTime.hour, pickedTime.minute);

    print("datetime: $dateTime");

    var dateTimeConv = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(dateTime);
    var offset = dateTime.timeZoneOffset;
    var hours = offset.inHours > 0 ? offset.inHours : 1;

    setState(() {
      if (!offset.isNegative) {
        dateTimeConv =
            "$dateTimeConv+${offset.inHours.toString().padLeft(2, '0')}:${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}";
      } else {
        dateTimeConv =
            "$dateTimeConv-${offset.inHours.toString().padLeft(2, '0')}:${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}";
      }
      // _date.text = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(dateTime);
      // _date.text = dateTimeConv;
      var date = DateFormat.yMEd().format(dateTime);
      var time = DateFormat.jm().format(dateTime);
      _date.text = "$date, $time";
      pickedDateTime = dateTimeConv;
    });
    // setState(() {});
  }

  // _getHall() async {
  //   List<HallsResponse>? halls = await RemoteServices.halls(context);
  //   if (halls!.isNotEmpty) {
  //     setState(() {
  //       for (var hall in halls) {
  //         hall_list[hall.hallId] = hall.name;
  //       }
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(Constants.snackBar(context, "No Hall", false));
  //   }
  // }

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

  _getInvigilator(context) async {
    List<InvigilatorsListResponse?>? invigilators =
        await RemoteServices.invigilatorList(context);
    if (invigilators!.isNotEmpty) {
      for (var inv in invigilators) {
        invigilator_list[inv!.profileId] =
            "${inv.userId.username} - ${inv.userId.name}";
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
          context, "No Invigilator in your department", false));
    }
  }

  allocateHall(context) async {
    print("date:$pickedDateTime");
    var isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();

    AllocateHallResponse? allot = await RemoteServices.allocateHall(
        context, pickedDateTime, _level, _course, _invigilator.toString());
    if (allot != null) {
      await Constants.dialogBox(
        context,
        icon: Icons.check_circle_outline,
        text: "Hall and Seats Successfully Allocated",
        textColor: Constants.backgroundColor,
        actions: [
          TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: DefaultText(
                text: "Okay",
                color: Constants.backgroundColor,
                size: 18.0,
              )),
        ],
      );
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getHall();
    _getCourses();
    _getInvigilator(context);
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
                      iconSize: 25,
                    ),
                    const DefaultText(
                      text: "Allocate Hall",
                      size: 20.0,
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
                          icon: Icons.date_range,
                          label: "Date",
                          onTap: _pickDateTime,
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
                                allocateHall(context);
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
