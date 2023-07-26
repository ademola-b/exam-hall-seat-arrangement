import 'package:exam_seat_arrangement/screens/exam_officer/dashboard.dart';
import 'package:exam_seat_arrangement/screens/exam_officer/studentInvigilator.dart';
import 'package:exam_seat_arrangement/screens/more.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:fancy_bottom_navigation_2/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';

class ExamOfficerNavbar extends StatefulWidget {
  const ExamOfficerNavbar({super.key});

  @override
  State<ExamOfficerNavbar> createState() => _ExamOfficerNavbarState();
}

class _ExamOfficerNavbarState extends State<ExamOfficerNavbar> {
  int currentPage = 0;
  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: const [ExamOfficerDashboard(), StudentInvigilator(), More()],
      ),
      bottomNavigationBar: FancyBottomNavigation(
        circleColor: Constants.backgroundColor,
        activeIconColor: Constants.splashBackColor,
        inactiveIconColor: Constants.backgroundColor,
        barBackgroundColor: Constants.splashBackColor,
        textColor: Constants.backgroundColor,
        tabs: [
          TabData(iconData: Icons.home, title: "Home"),
          TabData(iconData: Icons.people, title: "Add Users"),
          TabData(iconData: Icons.more, title: "More"),
        ],
        initialSelection: 0,
        key: bottomNavigationKey,
        onTabChangedListener: (int position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
    );
  }
}
