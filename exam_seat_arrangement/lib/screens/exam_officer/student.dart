import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:exam_seat_arrangement/main.dart';
import 'package:exam_seat_arrangement/models/user_response.dart';
import 'package:exam_seat_arrangement/services/remote_services.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultButton.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultDropDown.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:exam_seat_arrangement/utils/string_extension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  Map level = {'1': 'ND I', '2': 'ND II', '3': 'HND I', '4': 'HND II'};
  String? fileSelect = 'No file selected';
  bool _isDisabled = true;
  bool _isLoading = false;
  List<Map<String, dynamic>> listOfMap = [{}];

  final _form = GlobalKey<FormState>();
  late String _name;
  late String _regNo;
  late String _level;
  String? examOfficerDept;
  String? filePath;
  TextEditingController name = TextEditingController();
  TextEditingController regNo = TextEditingController();

  void _toggleLoading() {
    setState(() {
      _isLoading
          ? showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
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

      // print("fields: $fields");

      setState(() {
        // catch an exception if the user selects the wrong .csv file
        try {
          // check first row if contains the correct data(header)
          List<dynamic> fileHeader = fields.first;
          print("fileHeader: $fileHeader");
          if (fileHeader[2] != 'level') {
            ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
                context, "Oops!, you've selected the wrong file", false));
            fileSelect = "No File Selected";
          } else {
            // convert the selected file to listToMap, skip the first row(header)
            listOfMap = fields.sublist(1).map((innerList) {
              return {
                'user_id': {
                  'name': innerList[0],
                  'username': innerList[1].toString().toUpperCase(),
                  'dept_id': examOfficerDept,
                },
                'level': innerList[2],
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
    setState(() {
      _isLoading = true;
    });

    await RemoteServices.createStudent(context, data: listOfMap);
    setState(() {
      fileSelect = "File Uploaded";
      _isDisabled = true;
      _isLoading = false;
    });
  }

  void _addStudent() async {
    var _isValid = _form.currentState!.validate();
    if (!_isValid) return;
    _form.currentState!.save();

    await RemoteServices.createStudent(context, data: [
      {
        "user_id": {
          "name": _name.toUpperCase(),
          "username": _regNo.toUpperCase(),
          "dept_id": sharedPreferences.getString("examOfficerDept")
        },
        "level": _level
      }
    ]);

    _reset();
    Navigator.pop(context);
  }

  void _reset() async {
    name = TextEditingController(text: '');
    regNo = TextEditingController(text: '');
  }

  _getUser() async {
    UserDetailsResponse? user = await RemoteServices.userResponse(context);
    // return user;
    user != null
        ? setState(() {
            examOfficerDept = user.deptId;
          })
        : ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
            context, "Can't get exam officer details", false));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var dropdownvalue;
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
                      text: "Add Student",
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
                                          _isLoading = true;
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
                                          _isLoading = true;
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
                          obscureText: false,
                          fontSize: 20.0,
                          label: "Registration No",
                          onSaved: (value) {
                            _regNo = value!;
                          },
                          validator: Constants.validator,
                        ),
                        const SizedBox(height: 20.0),
                        DefaultDropDown(
                          onSaved: (newVal) {
                            _level = newVal;
                          },
                          validator: (value) {
                            if (value == null) return "field is required";
                            return null;
                          },
                          value: dropdownvalue,
                          onChanged: (newVal) {
                            setState(() {
                              dropdownvalue = newVal!;
                            });
                          },
                          dropdownMenuItemList: level
                              .map((key, value) => MapEntry(
                                  key,
                                  DropdownMenuItem(
                                      value: key,
                                      child: DefaultText(
                                        text: value.toString(),
                                        color: Constants.primaryColor,
                                      ))))
                              .values
                              .toList(),
                          text: "Level",
                        ),
                        const SizedBox(height: 50.0),
                        SizedBox(
                          width: size.width,
                          child: DefaultButton(
                              onPressed: () {
                                _addStudent();
                              },
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
