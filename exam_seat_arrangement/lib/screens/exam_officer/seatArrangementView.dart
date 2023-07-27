import 'dart:io';

import 'package:csv/csv.dart';
import 'package:exam_seat_arrangement/models/courses_responses.dart';
import 'package:exam_seat_arrangement/models/halls_response.dart';
import 'package:exam_seat_arrangement/models/seat_arrangement_response.dart';
import 'package:exam_seat_arrangement/services/remote_services.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultButton.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SeatArrangementView extends StatefulWidget {
  final arguments;
  const SeatArrangementView(Object? this.arguments, {super.key});

  @override
  State<SeatArrangementView> createState() => _SeatArrangementViewState();
}

class _SeatArrangementViewState extends State<SeatArrangementView> {
  String? _hall_name;
  String? _course_name;
  List<SeatArrangementResponse> seatResponse = [];
  String? hall_seats;
  int? seats_allocated;

  _getHallAndCourseName() async {
    List<HallsResponse>? hall = await RemoteServices.hallsWithId(
        context, widget.arguments['hall_id'] ?? '100');
    List<CoursesResponse>? course = await RemoteServices.courseWithId(
        context, widget.arguments['course'] ?? '100');
    if (hall!.isNotEmpty) {
      setState(() {
        _hall_name = hall[0].name;
      });
    }
    if (course!.isNotEmpty) {
      setState(() {
        _course_name = course[0].courseDesc;
      });
    }
  }

  Future<void> _exportList(context) async {
    if (seatResponse.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "Nothing to export", false));
    } else {
      List<List<String>> csvData = [
        <String>[
          widget.arguments['date'],
          _hall_name as String,
          _course_name as String
        ],
        <String>['Name', 'Registration No', 'Seat Number'],
        ...seatResponse.map((data) => [
              data.studentId.userId.name,
              data.studentId.userId.username,
              data.seatNo.toString()
            ])
      ];

      // convert list to csv
      String csv = const ListToCsvConverter().convert(csvData);

      // set the directory to save file
      final String dir = await Constants.getDownloadPath(context);
      final String path =
          "$dir/seat-arrangement-${widget.arguments['date']}.csv";

      // write file
      final File file = File(path);
      await file.writeAsString(csv);

      Constants.dialogBox(
        context,
        text: "Hall and Seats Successfully Allocated",
        color: Colors.white,
        textColor: Constants.primaryColor,
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
    }
  }

  _getSeatArrangement() async {
    List<SeatArrangementResponse>? seatArr =
        await RemoteServices.seatArrangementForExamOfficer(
            context,
            widget.arguments['date'],
            widget.arguments['hall_id'],
            widget.arguments['course']);
    if (seatArr != null && seatArr.isNotEmpty) {
      setState(() {
        seatResponse = seatArr;
        seats_allocated = seatArr.length;
        hall_seats = seatArr[0].hallId.seatNo.toString();
      });
    } else {
      setState(() {
        seats_allocated = 0;
        hall_seats = '0';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getHallAndCourseName();
    _getSeatArrangement();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios,
                          color: Constants.splashBackColor),
                      iconSize: 25,
                    ),
                    Expanded(
                      child: DefaultText(
                        text: "SEAT ARRANGEMENT VIEW",
                        size: 20.0,
                        color: Constants.splashBackColor,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 40.0),
                DefaultContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const DefaultText(
                              text: "Date",
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                            DefaultText(
                              text: widget.arguments['date'] ?? DateTime.now(),
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const DefaultText(
                              text: "Hall Name",
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                            DefaultText(
                              text: _hall_name ?? 'No Hall Returned',
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const DefaultText(
                              text: "Course",
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                            DefaultText(
                              text: _course_name ?? 'No Course Returned',
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const DefaultText(
                              text: "Seats Allocated",
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                            DefaultText(
                              text: "$seats_allocated/$hall_seats",
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // SizedBox(
                    //   child: DefaultButton(
                    //       onPressed: () {},
                    //       text: "Shuffle List",
                    //       textColor: Constants.splashBackColor,
                    //       textSize: 18.0),
                    // ),
                    SizedBox(
                      child: DefaultButton(
                          onPressed: () {
                            _exportList(context);
                          },
                          text: "Export List",
                          textColor: Constants.splashBackColor,
                          textSize: 18.0),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  height: size.height / 1.8,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FutureBuilder(
                            future:
                                RemoteServices.seatArrangementForExamOfficer(
                                    context,
                                    widget.arguments['date'],
                                    widget.arguments['hall_id'],
                                    widget.arguments['course']),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data!.isEmpty) {
                                return SizedBox(
                                  width: size.width,
                                  child: DefaultContainer(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/no_data.svg",
                                            width: 150,
                                            height: 150,
                                          ),
                                          const SizedBox(height: 30.0),
                                          DefaultText(
                                            text:
                                                "No Seat Arrangements for the supplied data",
                                            size: 22.0,
                                            color: Constants.pillColor,
                                            align: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                var data = snapshot.data;
                                return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: data!.length,
                                    itemBuilder: (context, index) {
                                      return DefaultContainer(
                                        child: ListTile(
                                          title: DefaultText(
                                              size: 18.0,
                                              text: data[index]
                                                  .studentId
                                                  .userId
                                                  .name),
                                          subtitle: DefaultText(
                                              text: data[index]
                                                  .studentId
                                                  .userId
                                                  .username),
                                          trailing: CircleAvatar(
                                            radius: 50,
                                            backgroundColor:
                                                Constants.pillColor,
                                            child: DefaultText(
                                              text:
                                                  data[index].seatNo.toString(),
                                              size: 18.0,
                                              color: Constants.splashBackColor,
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }

                              return CircularProgressIndicator(
                                color: Constants.splashBackColor,
                              );
                            })
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
