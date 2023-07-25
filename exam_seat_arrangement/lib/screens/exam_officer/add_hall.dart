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

class AddHall extends StatefulWidget {
  const AddHall({super.key});

  @override
  State<AddHall> createState() => _AddHallState();
}

class _AddHallState extends State<AddHall> {
  String? fileSelect = 'No file selected';
  bool _isDisabled = true;
  final _form = GlobalKey<FormState>();
  late String _hallName;
  late String _seat_no;
  // TextEditingController _seatNo = TextEditingController();
  bool _isLoading = false;

  List<Map<String, dynamic>> listOfMaps = [{}];
  String? filePath;

  _addHall(context) async {
    var isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();

    listOfMaps = [
      {'name': _hallName, 'seat_no': _seat_no.toString()}
    ];

    await RemoteServices.createHall(context, data: listOfMaps);

    Navigator.popAndPushNamed(context, '/halls');
  }

  void _toggleLoading() {
    setState(() {
      _isLoading
          ? showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                  child: CircularProgressIndicator(
                color: Constants.primaryColor,
              )),
            )
          : const SizedBox.shrink();
    });
  }

  void _pickFile() async {
    _toggleLoading();
    setState(() {
      _isLoading = true;
    });
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    // check if no file is picked
    if (result == null) {
      Navigator.pop(context);
      return;
    }

    filePath = result.files.first.path!;

    final String extension = path.extension(filePath!);

    if (extension.toLowerCase() == '.csv') {
      final input = File(filePath!).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();

      print(fields);

      setState(() {
        // catch an exception if the user selects the wrong .csv file
        try {
          // get the first row
          List<dynamic> fileHeader = fields.first;
          print("File Header: $fileHeader");

          if (fileHeader[1] != 'seat_no') {
            print("here");

            ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
                context, "Oops!, you've selected the wrong file", false));
            // fileSelect = "No File Selected";
          } else {
            listOfMaps = fields.sublist(1).map((innerList) {
              List<String> keys = ['name', 'seat_no'];
              return Map.fromIterables(keys, innerList);
            }).toList();
            _isDisabled = false;
            fileSelect = "File Selected";
          }
        } on ArgumentError catch (e) {
          listOfMaps = [{}];
          ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
              context, "Oops!, you've selected the wrong file", false));
          fileSelect = "No File Selected";
          print("I'm here");
          _isLoading = false;
          _toggleLoading();
          setState(() {});
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
              Constants.snackBar(context, "An error occured: $e", false));
        }

        print("listOfMaps: $listOfMaps");
        // fileSelect = "File Selected";
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "Invalid File Selected!!", false));
    }

    // Navigator.pop(context);
  }

  void _upload(context) async {
    _isLoading = true;
    _toggleLoading();
    await RemoteServices.createHall(context, data: listOfMaps);
    // _isLoading = false;
    // _toggleLoading();
    Navigator.popAndPushNamed(context, '/halls');
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
                                          _isDisabled ? null : _upload(context);
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
                          obscureText: false,
                          fontSize: 20.0,
                          label: "No. of Seats",
                          validator: Constants.validator,
                          onSaved: (value) => _seat_no = value!,
                          keyboardInputType: TextInputType.number,
                        ),
                        const SizedBox(height: 20.0),
                        SizedBox(
                          width: size.width,
                          child: DefaultButton(
                              onPressed: () {
                                _addHall(context);
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
