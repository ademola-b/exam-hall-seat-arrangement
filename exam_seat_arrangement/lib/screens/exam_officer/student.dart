import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultButton.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultDropDown.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:flutter/material.dart';

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  Map level = {'1': '100', '2': '200'};
  String? fileSelect = 'No file selected';
  final bool _isDisabled = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.splashBackColor,
        // appBar: AppBar(
        //   title: const DefaultText(text: "Add Student", size: 18.0),
        //   centerTitle: true,
        // ),
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
                      text: "Add Student",
                      size: 30.0,
                      color: Constants.primaryColor,
                    )
                  ],
                ),
                const SizedBox(height: 40.0),
                DefaultContainer(
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
                const SizedBox(height: 70.0),
                Form(
                    child: Column(
                  children: [
                    const DefaultTextFormField(
                        obscureText: false, fontSize: 25.0),
                    const SizedBox(height: 20.0),
                    const DefaultTextFormField(
                        obscureText: false, fontSize: 25.0),
                    const SizedBox(height: 20.0),
                    DefaultDropDown(
                        onChanged: (newVal) {},
                        dropdownMenuItemList: level
                            .map((key, value) => MapEntry(
                                key,
                                DropdownMenuItem(
                                    value: key,
                                    child:
                                        DefaultText(text: value.toString()))))
                            .values
                            .toList(),
                        text: "Level",
                        onSaved: (newVal) {}),
                    const SizedBox(height: 50.0),
                    SizedBox(
                      width: size.width,
                      child: DefaultButton(
                          onPressed: () {},
                          text: "Add Student",
                          textSize: 20.0),
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
