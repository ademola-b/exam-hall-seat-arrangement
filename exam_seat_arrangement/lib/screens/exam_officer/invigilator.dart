import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:exam_seat_arrangement/main.dart';
import 'package:exam_seat_arrangement/services/remote_services.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultButton.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:exam_seat_arrangement/utils/string_extension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

class Invigilator extends StatefulWidget {
  const Invigilator({super.key});

  @override
  State<Invigilator> createState() => _InvigilatorState();
}

class _InvigilatorState extends State<Invigilator> {
  String? fileSelect = 'No file selected';
  bool _isDisabled = true;
  bool _isLoading = false;
  List<Map<String, dynamic>> listOfMap = [{}];

  final _form = GlobalKey<FormState>();
  late String _name;
  late String _username;
  late String _phone;

  String? filePath;
  TextEditingController name = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController phone = TextEditingController();

  _addInvigilator() async {
    var _isValid = _form.currentState!.validate();
    if (!_isValid) return;
    _form.currentState!.save();

    await RemoteServices.createInvigilator(context, data: [
      {
        "user_id": {
          "username": _username.toUpperCase(),
          "name": _name.toTitleCase(),
          "dept_id": sharedPreferences.getString("examOfficerDept")
        },
        "phone": _phone
      }
    ]);

    _reset();
    Navigator.pop(context);
  }

  void _reset() async {
    name = TextEditingController(text: '');
    username = TextEditingController(text: '');
    phone = TextEditingController(text: '');
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
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    // check if no file is picked
    if (result == null) return;

    filePath = result.files.first.path!;

    final String extension = path.extension(filePath!);

    if (extension.toLowerCase() == '.csv') {
      final input = File(filePath!).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();

      print("fields: $fields");

      setState(() {
        // catch an exception if the user selects the wrong .csv file
        try {
          // check first row if contains the correct data(header)
          List<dynamic> fileHeader = fields.first;
          print("fileHeader: $fileHeader");

          if (fileHeader[2] != 'phone') {
            ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
                context, "Oops!, you've selected the wrong file", false));
          } else {
            // convert the selected file to listToMap, skip the first row(header)
            listOfMap = fields.sublist(1).map((innerList) {
              return {
                'user_id': {
                  'name': innerList[0],
                  'username': innerList[1].toString().toUpperCase(),
                  'dept_id': sharedPreferences.getString("examOfficerDept"),
                },
                'phone': innerList[2],
              };
            }).toList();

            _isDisabled = false;
            fileSelect = "File Selected";
          }
        } on ArgumentError catch (e) {
          listOfMap = [{}];
          ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
              context, "Oops!, you've selected the wrong file", false));
          fileSelect = "No File Selected";
          _isLoading = false;
          _toggleLoading();
          setState(() {});
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
              Constants.snackBar(context, "An error occured: $e", false));
        }

        print("listOfMap: $listOfMap");
        // fileSelect = "File Selected";
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "Invalid File Selected!!", false));
    }

    Navigator.pop(context);
  }

  void _uploadFile() async {
    await RemoteServices.createInvigilator(context, data: listOfMap);
    setState(() {
      fileSelect = "File Uploaded";
      _isDisabled = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                      text: "Add Invigilator",
                      size: 20.0,
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
                                  onPressed: () {
                                    _isLoading = true;
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
                                          _isDisabled ? null : _uploadFile();
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
                          text: name,
                          obscureText: false,
                          fontSize: 20.0,
                          label: "Name",
                          onSaved: (value) {
                            _name = value!;
                          },
                          validator: Constants.validator,
                        ),
                        const SizedBox(height: 20.0),
                        DefaultTextFormField(
                          text: username,
                          obscureText: false,
                          fontSize: 20.0,
                          label: "Username",
                          onSaved: (value) {
                            _username = value!;
                          },
                          validator: Constants.validator,
                        ),
                        const SizedBox(height: 20.0),
                        DefaultTextFormField(
                          text: phone,
                          obscureText: false,
                          fontSize: 20.0,
                          label: "Phone No",
                          keyboardInputType:
                              const TextInputType.numberWithOptions(),
                          onSaved: (value) {
                            _phone = value!;
                          },
                          validator: Constants.validator,
                        ),
                        const SizedBox(height: 50.0),
                        SizedBox(
                          width: size.width,
                          child: DefaultButton(
                              onPressed: () {
                                _addInvigilator();
                              },
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
