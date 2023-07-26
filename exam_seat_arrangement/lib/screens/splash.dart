import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:exam_seat_arrangement/main.dart';
import 'package:exam_seat_arrangement/models/user_response.dart';
import 'package:exam_seat_arrangement/screens/exam_officer/examOfficerNavbar.dart';
import 'package:exam_seat_arrangement/screens/login.dart';
import 'package:exam_seat_arrangement/screens/student/bottomNavbar.dart';
import 'package:exam_seat_arrangement/services/remote_services.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserDetailsResponse? user;
  var check_login = 0;

  // get the nextscreen
  // to be modified to return widget
  nextScreen(context) async {
    String? token = sharedPreferences.getString('token');
    if (token != null) {
      UserDetailsResponse? user = await RemoteServices.userResponse(context);
      if (user != null) {
        if (user.isExamofficer) {
          setState(() {
            check_login = 1;
          });
        } else if (user.isInvigilator || user.isStudent) {
          setState(() {
            check_login = 2;
          });
        } else {
          setState(() {
            check_login = 0;
          });
          
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(Constants.snackBar(context, "Invalid User", false));
      }
    }

    return null;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nextScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset("assets/images/logo.png",
                    width: 250, height: 250),
              )
            ],
          ),
        ),
        backgroundColor: Constants.backgroundColor,
        splashIconSize: 300.0,
        nextScreen: check_login == 1
            ? const ExamOfficerNavbar()
            : check_login == 2
                ? const Navbar()
                : const Login());
  }
}
