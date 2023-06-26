import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:flutter/material.dart';

class Constants {
  static final Color backgroundColor = Color(0xFF216865);
  // static final Color altColor = Color(0xFF155451);
  static  const Color primaryColor = Color(0xFF155451);
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

  static dialogBox(
      context, {String? text, Color? color, Color? textColor, IconData? icon,
      String? buttonText, void Function()? buttonAction}) {
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
              actions: [
                TextButton(
                    onPressed: buttonAction,
                    child: DefaultText(
                      text: "$buttonText",
                      color: Colors.blue,
                      size: 18.0,
                    )),
              ],
            ));
  }


  
}
