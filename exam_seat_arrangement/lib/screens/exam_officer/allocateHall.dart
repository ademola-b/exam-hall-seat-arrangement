import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultButton.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultDropDown.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:flutter/material.dart';

class AllocateHall extends StatefulWidget {
  const AllocateHall({super.key});

  @override
  State<AllocateHall> createState() => _AllocateHallState();
}

class _AllocateHallState extends State<AllocateHall> {
  Map hall_list = {'1': 'HND1', '2': 'ND2'};
  Map level = {'1': 'HND1', '2': 'ND2'};
  Map invigilator = {'1': 'Agbabiaka', '2': 'Folarin'};

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.splashBackColor,
        // appBar: AppBar(
        //   title: const DefaultText(text: "Add AllocateHall", size: 18.0),
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
                      text: "Allocate Hall",
                      size: 25.0,
                      color: Constants.primaryColor,
                    )
                  ],
                ),
                const SizedBox(height: 40.0),
                const SizedBox(height: 70.0),
                Form(
                    child: Column(
                  children: [
                    const DefaultTextFormField(
                        obscureText: false, fontSize: 25.0, label: "Date"),
                    const SizedBox(height: 20.0),
                    DefaultDropDown(
                        onChanged: (newVal) {},
                        dropdownMenuItemList: [],
                        text: "Semester",
                        onSaved: (dynamic) {}),
                    const SizedBox(height: 20.0),
                    DefaultDropDown(
                        onChanged: (newVal) {},
                        dropdownMenuItemList: hall_list
                            .map((key, value) => MapEntry(
                                key,
                                DropdownMenuItem(
                                  value: key,
                                  child: DefaultText(
                                    text: value.toString(),
                                  ),
                                )))
                            .values
                            .toList(),
                        text: "Hall",
                        onSaved: (dynamic) {}),
                    const SizedBox(height: 20.0),
                    const DefaultTextFormField(
                      obscureText: false,
                      fontSize: 25.0,
                      label: "No. of Seats",
                    ),
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
                    const SizedBox(height: 20.0),
                    DefaultDropDown(
                        onChanged: (newVal) {},
                        dropdownMenuItemList: invigilator
                            .map((key, value) => MapEntry(
                                key,
                                DropdownMenuItem(
                                    value: key,
                                    child:
                                        DefaultText(text: value.toString()))))
                            .values
                            .toList(),
                        text: "Invigilator",
                        onSaved: (newVal) {}),
                    const SizedBox(height: 70.0),
                    SizedBox(
                      width: size.width,
                      child: DefaultButton(
                          onPressed: () {},
                          text: "Allocate Hall",
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
