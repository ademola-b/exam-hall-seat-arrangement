import 'package:exam_seat_arrangement/screens/exam_officer/allocateHall.dart';
import 'package:exam_seat_arrangement/screens/exam_officer/allocatedHalls.dart';
import 'package:exam_seat_arrangement/screens/exam_officer/examOfficerNavbar.dart';
import 'package:exam_seat_arrangement/screens/exam_officer/add_hall.dart';
import 'package:exam_seat_arrangement/screens/exam_officer/halls.dart';
import 'package:exam_seat_arrangement/screens/exam_officer/invigilator.dart';
import 'package:exam_seat_arrangement/screens/exam_officer/seatArrangement.dart';
import 'package:exam_seat_arrangement/screens/exam_officer/seatArrangementView.dart';
import 'package:exam_seat_arrangement/screens/exam_officer/student.dart';
import 'package:exam_seat_arrangement/screens/exam_officer/update_allocation.dart';
import 'package:exam_seat_arrangement/screens/login.dart';
import 'package:exam_seat_arrangement/screens/splash.dart';
import 'package:exam_seat_arrangement/screens/student/bottomNavbar.dart';
import 'package:exam_seat_arrangement/screens/change_password.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
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

    case '/login':
      return _buildRoute(settings, const Login());

    case '/examOfficerNavbar':
      return _buildRoute(settings, const ExamOfficerNavbar());

    case '/addHall':
      return _buildRoute(settings, const AddHall());

    case '/halls':
      return _buildRoute(settings, const Halls());

    case '/allocateHall':
      return _buildRoute(settings, const AllocateHall());

    case '/updateAllocation':
      return _buildRoute(settings, const UpdateAllocation());

    case '/allocatedHalls':
      return _buildRoute(settings, const AllocatedHalls());

    case '/seatArrangement':
      return _buildRoute(settings, const SeatArrangement());

    case '/seatArrangementView':
      return _buildRoute(settings, SeatArrangementView(settings.arguments));

    case '/student':
      return _buildRoute(settings, const Student());

    case '/invigilator':
      return _buildRoute(settings, const Invigilator());

    case '/changePassword':
      return _buildRoute(settings, const ChangePassword());

    default:
      return _buildRoute(settings, const SplashScreen());
  }
}

MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
  return MaterialPageRoute(settings: settings, builder: ((context) => builder));
}
