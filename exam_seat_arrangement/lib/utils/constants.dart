import 'dart:io';

import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Constants {
  static final Color backgroundColor = Color(0xFF216865);
  // static final Color altColor = Color(0xFF155451);
  static const Color primaryColor = Color(0xFF155451);
  static final Color altColor = Color(0xFFd8c6ad);
  static final Color pillColor = Color(0xFFc01414);
  static final Color splashBackColor = Color(0xFFffefd8);

  static String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "This Field is required";
    }
    return null;
  }

  static SnackBar snackBar(context, String text, bool response) {
    return SnackBar(
      content: DefaultText(
        text: text,
      ),
      backgroundColor:
          response ? Constants.backgroundColor : Constants.pillColor,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Dismiss',
        disabledTextColor: Constants.splashBackColor,
        textColor: Colors.yellow,
        onPressed: () {
          // Navigator.pop(context);
        },
      ),
    );
  }

  static dialogBox(context,
      {String? text,
      Color? color,
      Color? textColor,
      IconData? icon,
      String? buttonText,
      List<Widget>? actions,
      void Function()? buttonAction}) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: color,
              content: SizedBox(
                height: 180.0,
                child: Column(
                  children: [
                    Icon(
                      icon,
                      size: 70.0,
                      color: Constants.backgroundColor,
                    ),
                    const SizedBox(height: 20.0),
                    DefaultText(
                      size: 20.0,
                      text: text!,
                      color: textColor,
                      align: TextAlign.center,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              actions: actions,
            ));
  }

  static pickDate(context, DateTime pickedDate) async {
    var picked = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                    primary: Constants.primaryColor,
                    onPrimary: Constants.splashBackColor,
                    onSurface: Constants.pillColor)),
            child: child!);
      },
    );

    return picked;
  }

  static pickTime(context, DateTime pickedTime) async {
    var pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 00, minute: 00),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                    primary: Constants.primaryColor,
                    onPrimary: Constants.splashBackColor,
                    onSurface: Constants.pillColor)),
            child: child!);
      },
    );
    if (pickedTime != null) {
      return pickedTime;
    }
  }

  static Future<String> getDownloadPath(context) async {
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
}
