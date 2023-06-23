import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/string_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class StudentInvigilator extends StatefulWidget {
  const StudentInvigilator({super.key});

  @override
  State<StudentInvigilator> createState() => _StudentInvigilatorState();
}

class _StudentInvigilatorState extends State<StudentInvigilator> {
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
                      // text: "Hello, \n ${_username.titleCase()}",
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                    const SizedBox(height: 70.0),
                    DefaultContainer(
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
                                        color: Constants.backgroundColor,
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/student');
                                          },
                                          icon: const Icon(Icons.people),
                                          iconSize: 70,
                                          color: Constants.splashBackColor,
                                        ),
                                      ),
                                    ),
                                    DefaultText(
                                      text: "Students",
                                      size: 20.0,
                                      color: Constants.primaryColor,
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                child: Column(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        color: Constants.primaryColor,
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/invigilator');
                                          },
                                          icon: const Icon(Icons.people),
                                          iconSize: 70,
                                          color: Constants.splashBackColor,
                                        ),
                                      ),
                                    ),
                                    DefaultText(
                                      text: "Invigilator",
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
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
