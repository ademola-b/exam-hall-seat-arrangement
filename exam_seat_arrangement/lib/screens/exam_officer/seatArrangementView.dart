import 'package:exam_seat_arrangement/models/courses_responses.dart';
import 'package:exam_seat_arrangement/models/halls_response.dart';
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

  @override
  void initState() {
    super.initState();
    _getHallAndCourseName();
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
                      iconSize: 30,
                    ),
                    DefaultText(
                      text: "SEAT ARRANGEMENT VIEW",
                      size: 25.0,
                      color: Constants.splashBackColor,
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
                          children: const [
                            DefaultText(
                              text: "Seats Allocated",
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                            DefaultText(
                              text: "XXXXXXX",
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
                    SizedBox(
                      child: DefaultButton(
                          onPressed: () {},
                          text: "Export List",
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
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: data!.length,
                                    itemBuilder: (context, index) {
                                      return DefaultContainer(
                                        child: ListTile(
                                          title: DefaultText(
                                              text: data[index]!
                                                  .studentId
                                                  .userId
                                                  .name),
                                          subtitle: DefaultText(
                                              text: data[index]!
                                                  .studentId
                                                  .userId
                                                  .username),
                                          trailing: ClipOval(
                                            child: Container(
                                                color: Constants.pillColor,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      18.0),
                                                  child: DefaultText(
                                                    text: data[index]!
                                                        .seatNo
                                                        .toString(),
                                                    size: 15.0,
                                                    color: Constants
                                                        .splashBackColor,
                                                  ),
                                                )),
                                          ),
                                        ),
                                      );
                                    });
                              }

                              return const CircularProgressIndicator();
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
