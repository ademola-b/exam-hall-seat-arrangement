import 'dart:convert';

import 'package:exam_seat_arrangement/main.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:flutter/material.dart';

class More extends StatefulWidget {
  const More({Key? key}) : super(key: key);

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  String? userType;
  List stdCourse = [];

  var profile_pic;

  final List<String> _labels = [
    "Personal Information",
    "Change password",
    "About Application",
  ];

  final List<IconData> _labelIcons = [
    Icons.person,
    Icons.lock,
    Icons.add,
  ];

  final List<String> _labelRoutes = ['/profile', '/changePassword', '/about'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            // appBar: AppBar(
            //   title: const DefaultText(text: 'PROFILE', size: 22.0),
            //   centerTitle: true,
            // ),
            backgroundColor: Constants.backgroundColor,
            body: Padding(
              padding:
                  const EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0),
              child: Column(children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 150.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          border: Border.all(
                              color: Constants.splashBackColor, width: 4.0),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/logo.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      DefaultText(
                        size: 25.0,
                        text: "Name",
                        weight: FontWeight.bold,
                        color: Constants.splashBackColor,
                      ),
                      DefaultText(
                          size: 18.0,
                          text: "registration number",
                          color: Constants.splashBackColor,
                          weight: FontWeight.bold),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _labels.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Constants.splashBackColor,
                            border: Border.all(
                                color: Constants.splashBackColor, width: 0.2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: ListTile(
                            textColor: Constants.splashBackColor,
                            leading: Icon(
                              _labelIcons[index],
                              color: Constants.backgroundColor,
                            ),
                            title: DefaultText(
                              text: _labels[index],
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, _labelRoutes[index]);
                            },
                          ),
                        );
                      }),
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.red),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: ListTile(
                    textColor: Colors.red,
                    leading: const Icon(Icons.logout),
                    title: const DefaultText(size: 15.0, text: "Logout"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      sharedPreferences.clear();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                    },
                  ),
                ),
              ]),
            )));
  }
}
