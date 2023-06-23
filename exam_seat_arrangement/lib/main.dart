import 'package:exam_seat_arrangement/screens/exam_officer/allocateHall.dart';
import 'package:exam_seat_arrangement/screens/exam_officer/examOfficerNavbar.dart';
import 'package:exam_seat_arrangement/screens/exam_officer/hall.dart';
import 'package:exam_seat_arrangement/screens/exam_officer/invigilator.dart';
import 'package:exam_seat_arrangement/screens/exam_officer/seatArrangement.dart';
import 'package:exam_seat_arrangement/screens/exam_officer/seatArrangementView.dart';
import 'package:exam_seat_arrangement/screens/exam_officer/student.dart';
import 'package:exam_seat_arrangement/screens/splash.dart';
import 'package:exam_seat_arrangement/screens/student/bottomNavbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    onGenerateRoute: getRoutes,
  ));
}

Route<dynamic> getRoutes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return _buildRoute(settings, const SplashScreen());

    case '/bottomNavbar':
      return _buildRoute(settings, const Navbar());

    case '/examOfficerNavbar':
      return _buildRoute(settings, const ExamOfficerNavbar());

    case '/hall':
      return _buildRoute(settings, const Hall());

    case '/allocateHall':
      return _buildRoute(settings, const AllocateHall());

    case '/seatArrangement':
      return _buildRoute(settings, const SeatArrangement());
  
    case '/seatArrangementView':
      return _buildRoute(settings, const SeatArrangementView());
  
    case '/student':
      return _buildRoute(settings, const Student());
    
    case '/invigilator':
      return _buildRoute(settings, const Invigilator());

    default:
      return _buildRoute(settings, const SplashScreen());
  }
}

MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
  return MaterialPageRoute(settings: settings, builder: ((context) => builder));
}
