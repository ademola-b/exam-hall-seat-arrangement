import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultButton.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:flutter/material.dart';

class Hall extends StatefulWidget {
  const Hall({super.key});

  @override
  State<Hall> createState() => _HallState();
}

class _HallState extends State<Hall> {
  String? fileSelect = 'No file selected';
  final bool _isDisabled = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.splashBackColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios,
                          color: Constants.backgroundColor),
                      iconSize: 30,
                    ),
                    DefaultText(
                      text: "Add Hall",
                      size: 25.0,
                      color: Constants.primaryColor,
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
                            SizedBox(
                              width: size.width / 2.5,
                              child: DefaultButton(
                                  onPressed: () {},
                                  text: "Select File",
                                  textSize: 20.0),
                            ),
                            SizedBox(
                              width: size.width / 2.5,
                              child: DefaultButton(
                                  onPressed: () {
                                    _isDisabled ? null : print("object");
                                  },
                                  text: "Upload File",
                                  textSize: 20.0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        DefaultText(
                            text: "$fileSelect",
                            size: 18.0,
                            color: Constants.primaryColor)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 70.0),
                Form(
                    child: Column(
                  children: [
                    const DefaultTextFormField(
                      obscureText: false,
                      fontSize: 25.0,
                      label: "Hall Name",
                    ),
                    const SizedBox(height: 20.0),
                    const DefaultTextFormField(
                      obscureText: false,
                      fontSize: 25.0,
                      label: "No. of Seats",
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: size.width,
                      child: DefaultButton(
                          onPressed: () {}, text: "Add Hall", textSize: 20.0),
                    )
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
