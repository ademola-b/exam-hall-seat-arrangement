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
import 'package:flutter_svg/flutter_svg.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _username = "user";
  bool userType = false;

  String today = DateFormat("yyyy-MM-dd").format(DateTime.now());

  _getUser() async {
    UserDetailsResponse? user = await RemoteServices.userResponse(context);
    // return user;
    if (user != null) {
      setState(() {
        userType = user.isStudent;
        _username = user.username;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    // print("today: $today");
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: () => RemoteServices.viewSeatArrangement(context, today),
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 40.0),
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
                      !userType
                          ? DefaultText(
                              text: "Hall Allocation for today".toUpperCase(),
                              size: 22.0,
                              color: Constants.splashBackColor,
                              align: TextAlign.center,
                            )
                          : DefaultText(
                              text: "hall allocation and seat no. for today"
                                  .toUpperCase(),
                              size: 22.0,
                              color: Constants.splashBackColor,
                              align: TextAlign.center,
                            ),
                      const SizedBox(height: 30.0),
                      FutureBuilder(
                          future: RemoteServices.viewSeatArrangement(
                              context, today),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data!.isEmpty) {
                              return SizedBox(
                                width: size.width,
                                child: DefaultContainer(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/no_data.svg",
                                          width: 150,
                                          height: 150,
                                        ),
                                        const SizedBox(height: 30.0),
                                        DefaultText(
                                          text: "No Allocation yet for today",
                                          size: 22.0,
                                          color: Constants.pillColor,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasData) {
                              var data = snapshot.data;
                              return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: data!.length,
                                  itemBuilder: (context, index) {
                                    return DefaultContainer(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                const DefaultText(
                                                  text: "COURSE",
                                                  size: 20.0,
                                                  color: Constants.primaryColor,
                                                ),
                                                DefaultText(
                                                  text: data[index]!
                                                      .allocationId
                                                      .course
                                                      .courseTitle,
                                                  size: 20.0,
                                                  color: Constants.pillColor,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                const DefaultText(
                                                  text: "HALL NAME",
                                                  size: 20.0,
                                                  color: Constants.primaryColor,
                                                ),
                                                DefaultText(
                                                  text:
                                                      data[index]!.hallId.name,
                                                  size: 20.0,
                                                  color: Constants.pillColor,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20.0),
                                            userType
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      const DefaultText(
                                                        text: "SEAT NO.",
                                                        size: 20.0,
                                                        color: Constants
                                                            .primaryColor,
                                                      ),
                                                      DefaultText(
                                                        text: data[index]!
                                                            .seatNo
                                                            .toString(),
                                                        size: 25.0,
                                                        color:
                                                            Constants.pillColor,
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox.shrink(),
                                            const SizedBox(height: 20.0),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }
                            return const CircularProgressIndicator();
                          }),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
