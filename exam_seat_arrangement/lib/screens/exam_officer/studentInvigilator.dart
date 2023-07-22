import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/string_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DefaultContainer(
                      // text: "Hello, \n ${_username.titleCase()}",
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            DefaultText(
                              size: 20.0,
                              align: TextAlign.center,
                              text: "Add Users",
                              color: Constants.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 70.0),
                    DefaultContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/student'),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/student.svg",
                                        width: 100,
                                        height: 100,
                                      ),
                                      const DefaultText(
                                        text: "Add Students",
                                        size: 18.0,
                                        color: Constants.primaryColor,
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, '/invigilator'),
                                  child: Column(
                                    children: [
                                      ClipOval(
                                        child: SvgPicture.asset(
                                          "assets/images/invigilator.svg",
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
                                      const DefaultText(
                                        text: "Add Invigilator",
                                        size: 18.0,
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
      ),
    );
  }
}
