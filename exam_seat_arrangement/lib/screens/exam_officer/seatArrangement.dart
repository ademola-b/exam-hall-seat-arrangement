import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultButton.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultDropDown.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:flutter/material.dart';

class SeatArrangement extends StatefulWidget {
  const SeatArrangement({super.key});

  @override
  State<SeatArrangement> createState() => _SeatArrangementState();
}

class _SeatArrangementState extends State<SeatArrangement> {
  Map hall_list = {'1': 'HND1', '2': 'ND2'};

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.splashBackColor,
        // appBar: AppBar(
        //   title: const DefaultText(text: "Add SeatArrangement", size: 18.0),
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
                      text: "SEAT ARRANGEMENT",
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
                      obscureText: false,
                      fontSize: 25.0,
                      label: "Date",
                    ),
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
                    const SizedBox(height: 70.0),
                    SizedBox(
                      width: size.width,
                      child: DefaultButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/seatArrangementView');
                          },
                          text: "View Seat Arrangement",
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
