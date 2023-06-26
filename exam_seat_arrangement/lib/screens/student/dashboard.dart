import 'package:exam_seat_arrangement/main.dart';
import 'package:exam_seat_arrangement/models/user_response.dart';
import 'package:exam_seat_arrangement/services/remote_services.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:exam_seat_arrangement/utils/string_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _username = "user";

  _getUser() async {
    UserDetailsResponse? user = await RemoteServices.userResponse(
        context, sharedPreferences.getString('token'));
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
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                DefaultContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          size: 20.0,
                          text: "Hello, \n ${_username.toUpperCase()}",
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
                const DefaultTextFormField(
                  obscureText: false,
                  label: "Date",
                ),
                const SizedBox(height: 30.0),
                DefaultContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DefaultText(
                              text: "COURSE",
                              size: 20.0,
                              color: Constants.primaryColor,
                            ),
                            // const Spacer(),
                            DefaultText(
                              text: "XXX",
                              size: 20.0,
                              color: Constants.primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DefaultText(
                              text: "SEMESTER",
                              size: 20.0,
                              color: Constants.primaryColor,
                            ),
                            DefaultText(
                              text: "XXXXXX",
                              size: 20.0,
                              color: Constants.primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DefaultText(
                              text: "HALL NAME",
                              size: 20.0,
                              color: Constants.primaryColor,
                            ),
                            DefaultText(
                              text: "XXXXXX",
                              size: 20.0,
                              color: Constants.primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DefaultText(
                              text: "SEAT NO.",
                              size: 20.0,
                              color: Constants.primaryColor,
                            ),
                            DefaultText(
                              text: "XXXXXX",
                              size: 20.0,
                              color: Constants.primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    ));
  }
}
