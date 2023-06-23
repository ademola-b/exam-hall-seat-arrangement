import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultButton.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultDropDown.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:flutter/material.dart';

class SeatArrangementView extends StatefulWidget {
  const SeatArrangementView({super.key});

  @override
  State<SeatArrangementView> createState() => _SeatArrangementViewState();
}

class _SeatArrangementViewState extends State<SeatArrangementView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        // appBar: AppBar(
        //   title: const DefaultText(text: "Add SeatArrangementView", size: 18.0),
        //   centerTitle: true,
        // ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios,
                          color: Constants.splashBackColor),
                      iconSize: 30,
                    ),
                    DefaultText(
                      text: "SEAT ARRANGEMENT VIEW",
                      size: 25.0,
                      color: Constants.splashBackColor,
                    )
                  ],
                ),
                const SizedBox(height: 40.0),
                DefaultContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DefaultText(
                              text: "Hall Name",
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                            DefaultText(
                              text: "XXXXXXX",
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DefaultText(
                              text: "Seats Allocated",
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                            DefaultText(
                              text: "XXXXXXX",
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DefaultText(
                              text: "Date",
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                            DefaultText(
                              text: "XXXXXXX",
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      child: DefaultButton(
                          onPressed: () {},
                          text: "Export List",
                          textSize: 18.0),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  height: size.height / 1.8,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              return DefaultContainer(
                                child: ListTile(
                                  title:
                                      const DefaultText(text: "Student's Name"),
                                  subtitle: const DefaultText(
                                      text: "Registration No"),
                                  trailing: ClipOval(
                                    child: Container(
                                        color: Constants.pillColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: DefaultText(
                                            text: "$index",
                                            size: 15.0,
                                            color: Constants.splashBackColor,
                                          ),
                                        )),
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
