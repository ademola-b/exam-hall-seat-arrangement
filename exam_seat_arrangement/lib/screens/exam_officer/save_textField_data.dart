import 'dart:io';

import 'package:csv/csv.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultButton.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class GetText extends StatefulWidget {
  const GetText({super.key});

  @override
  State<GetText> createState() => _GetTextState();
}

class _GetTextState extends State<GetText> {
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();

  List<TextFieldData> textData = [];

  Future<String> getDownloadPath(context) async {
    Directory? dir;
    // get the download folder
    try {
      Platform.isIOS
          ? dir = await getApplicationDocumentsDirectory()
          : dir = Directory('/storage/emulated/0/Download');
      // check external storage if download is not gotten
      if (!await dir.exists()) dir = await getExternalStorageDirectory();
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: DefaultText(
              size: 15.0,
              text:
                  "Can't get download folder, check if storage permission is enabled")));
    }

    return dir!.path;
  }

// save the data in a csv file
  Future<void> _generateCSV() async {
    // the file header
    List<List<String>> csvData = [
      <String>[
        'Name',
        'Age',
      ],
      ...textData.map((item) => [
            item.name,
            item.age,
          ])
    ];
    String csv = const ListToCsvConverter().convert(csvData);

    final String dir = (await getDownloadPath(context));
    final String path = "$dir/text-data.csv";
    // print(path);
    final File file = File(path);

    await file.writeAsString(csv);
  }

  _addDataToList() {
    textData.add(TextFieldData(name.text, age.text));
  }

  _getAndSaveText() async {
    _generateCSV();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: DefaultText(size: 15.0, text: "Data Saved")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Center(
          child: Column(
            children: [
              DefaultTextFormField(
                text: name,
                obscureText: false,
                fontSize: 20.0,
                label: "Name",
              ),
              const SizedBox(height: 20.0),
              DefaultTextFormField(
                text: age,
                obscureText: false,
                fontSize: 20.0,
                label: "Age",
              ),
              const SizedBox(height: 20.0),
              DefaultButton(
                  onPressed: () async{
                    await _addDataToList();
                    _getAndSaveText();
                  },
                  text: "Save Text",
                  textSize: 18.0)
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldData {
  String name;
  String age;

  TextFieldData(this.name, this.age);
}
