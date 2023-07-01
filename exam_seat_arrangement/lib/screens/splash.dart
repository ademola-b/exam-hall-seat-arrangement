import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:exam_seat_arrangement/main.dart';
import 'package:exam_seat_arrangement/models/user_response.dart';
import 'package:exam_seat_arrangement/screens/login.dart';
import 'package:exam_seat_arrangement/screens/student/bottomNavbar.dart';
import 'package:exam_seat_arrangement/services/remote_services.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserDetailsResponse? user;

  // get the nextscreen
  checkLogin(context) async {
    String? token = sharedPreferences.getString('token');
    if (token != null) {
      UserDetailsResponse? user = await RemoteServices.userResponse(context);
      if (user != null) {
        user.isExamofficer
            ? Navigator.popAndPushNamed(context, '/examOfficerNavbar')
            : user!.isInvigilator || user!.isStudent
                ? Navigator.popAndPushNamed(context, '/bottomNavbar')
                : Navigator.popAndPushNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(Constants.snackBar(context, "Invalid User", false));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin(context);
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
              // SvgPicture.asset("assets/images/logo.svg", width: 50.0, height: 50.0),
              // const SizedBox(height: 10.0),
              // const DefaultText(
              //   text: 'PLACE FINDER',
              //   size: 40.0,
              //   color: Colors.white,
              //   weight: FontWeight.bold,
              // ),
            ],
          ),
        ),
        backgroundColor: Constants.backgroundColor,
        splashIconSize: 300.0,
        nextScreen: const Login());
  }
}
