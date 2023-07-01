import 'package:exam_seat_arrangement/main.dart';
import 'package:exam_seat_arrangement/models/user_response.dart';
import 'package:exam_seat_arrangement/services/remote_services.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:exam_seat_arrangement/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExamOfficerDashboard extends StatefulWidget {
  const ExamOfficerDashboard({super.key});

  @override
  State<ExamOfficerDashboard> createState() => _ExamOfficerDashboardState();
}

class _ExamOfficerDashboardState extends State<ExamOfficerDashboard> {
  String _username = "exam officer";
  UserDetailsResponse? user;

  _getUser() async {
    user = await RemoteServices.userResponse(
        context);
    // return user;
    setState(() {
      _username = user!.username;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DefaultContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DefaultText(
                            size: 20.0,
                            text: "Hello, \n ${_username.toTitleCase()}",
                            // text: "Hello, \n ${username!.titleCase()}",
                            color: Constants.primaryColor,
                          ),
                          const Spacer(),
                          DefaultText(
                            size: 20.0,
                            align: TextAlign.center,
                            text:
                                "Date \n ${DateFormat("dd/MM/yyyy").format(DateTime.now())}",
                            color: Constants.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 70.0),
                  DefaultContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                child: Column(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        color: Constants.altColor,
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/hall');
                                          },
                                          icon:
                                              const Icon(Icons.account_balance),
                                          iconSize: 70,
                                          color: Constants.backgroundColor,
                                        ),
                                      ),
                                    ),
                                    DefaultText(
                                      text: "Hall",
                                      size: 20.0,
                                      color: Constants.primaryColor,
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, '/allocateHall'),
                                child: Column(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        color: Constants.backgroundColor,
                                        child: Image.asset(
                                          "assets/images/examination-hall.png",
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
                                    ),
                                    DefaultText(
                                      text: "Allocate Hall",
                                      size: 20.0,
                                      color: Constants.primaryColor,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, '/seatArrangement'),
                                child: Column(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        color: Constants.primaryColor,
                                        child: Image.asset(
                                          "assets/images/seat.jpg",
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
                                    ),
                                    DefaultText(
                                      text: "View Seat Arrangement",
                                      size: 20.0,
                                      color: Constants.primaryColor,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    ));
  }
}
