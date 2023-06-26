import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultButton.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:flutter/material.dart';

class Invigilator extends StatefulWidget {
  const Invigilator({super.key});

  @override
  State<Invigilator> createState() => _InvigilatorState();
}

class _InvigilatorState extends State<Invigilator> {
  String? fileSelect = 'No file selected';
  final bool _isDisabled = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.splashBackColor,
        // appBar: AppBar(
        //   title: const DefaultText(text: "Add Invigilator", size: 18.0),
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
                    const DefaultText(
                      text: "Add Invigilator",
                      size: 30.0,
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
                            _isDisabled
                                ? SizedBox(
                                    width: size.width / 2.5,
                                    child: DefaultButton(
                                        color: Colors.grey,
                                        onPressed: () {
                                          _isDisabled ? null : print("");
                                        },
                                        text: "Upload File",
                                        textSize: 20.0),
                                  )
                                : SizedBox(
                                    width: size.width / 2.5,
                                    child: DefaultButton(
                                        color: Constants.primaryColor,
                                        onPressed: () {
                                          _isDisabled ? null : print("");
                                        },
                                        text: "Upload File",
                                        textSize: 20.0),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        fileSelect!.startsWith('No')
                            ? DefaultText(
                                text: "$fileSelect",
                                size: 18.0,
                                color: Constants.pillColor)
                            : DefaultText(
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
                      label: "Name",
                    ),
                    const SizedBox(height: 20.0),
                    const DefaultTextFormField(
                      obscureText: false,
                      fontSize: 25.0,
                      label: "Phone No",
                      keyboardInputType: TextInputType.numberWithOptions(),
                    ),
                    const SizedBox(height: 50.0),
                    SizedBox(
                      width: size.width,
                      child: DefaultButton(
                          onPressed: () {},
                          text: "Add Invigilator",
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
