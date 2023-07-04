import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:exam_seat_arrangement/services/remote_services.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultButton.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class Hall extends StatefulWidget {
  const Hall({super.key});

  @override
  State<Hall> createState() => _HallState();
}

class _HallState extends State<Hall> {
  String? fileSelect = 'No file selected';
  bool _isDisabled = true;
  final _form = GlobalKey<FormState>();
  late String _hallName;
  late String _seat_no;
  // TextEditingController _seatNo = TextEditingController();
  bool _isLoading = false;

  late List<Map<String, dynamic>> listOfMaps;
  String? filePath;

  _addHall() async {
    var isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();

    listOfMaps = [
      {'name': _hallName, 'seat_no': _seat_no.toString()}
    ];

    await RemoteServices.createHall(context, data: listOfMaps);

    Navigator.pop(context);
  }

  void _pickFile() async {
    setState(() {
      _isLoading = true;
    });
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    // check if no file is picked
    if (result == null) return;
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) => const Center(child: CircularProgressIndicator()),
    // );

    filePath = result.files.first.path!;

    final String extension = path.extension(filePath!);

    if (extension.toLowerCase() == '.csv') {
      final input = File(filePath!).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();

      // print(fields);

      setState(() {
        // catch an exception if the user selects the wrong .csv file
        try {
          listOfMaps = fields.map((innerList) {
            List<String> keys = ['name', 'seat_no'];
            return Map.fromIterables(keys, innerList);
          }).toList();

          // loop through file to check if any of the record exists
          // display error message

          _isDisabled = false;
          fileSelect = "File Selected";
        } on ArgumentError catch (e) {
          listOfMaps = [{}];
          ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
              context, "Oops!, you've selected the wrong file", false));
          fileSelect = "No File Selected";
        }

        print("listOfMaps: $listOfMaps");
        // fileSelect = "File Selected";
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "Invalid File Selected!!", false));
    }
  }

  void _upload() async {
    // loop through file
    await RemoteServices.createHall(context, data: listOfMaps);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.splashBackColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                      iconSize: 25,
                    ),
                    const DefaultText(
                      text: "Add Hall",
                      size: 20.0,
                      color: Constants.primaryColor,
                    ),
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
                                  onPressed: () {
                                    _pickFile();
                                  },
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
                                          _isDisabled ? null : _upload();
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
                    key: _form,
                    child: Column(
                      children: [
                        DefaultTextFormField(
                          obscureText: false,
                          fontSize: 20.0,
                          label: "Hall Name",
                          validator: Constants.validator,
                          onSaved: (value) => _hallName = value!,
                        ),
                        const SizedBox(height: 20.0),
                        DefaultTextFormField(
                          // text: _seatNo,
                          obscureText: false,
                          fontSize: 20.0,
                          label: "No. of Seats",
                          validator: Constants.validator,
                          onSaved: (value) => _seat_no = value!,
                        ),
                        const SizedBox(height: 20.0),
                        SizedBox(
                          width: size.width,
                          child: DefaultButton(
                              onPressed: () {
                                _addHall();
                              },
                              text: "Add Hall",
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
