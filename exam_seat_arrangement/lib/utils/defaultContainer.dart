import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DefaultContainer extends StatelessWidget {
  final Widget? child;

  const DefaultContainer({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Constants.splashBackColor,
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          border: Border.all(color: Constants.backgroundColor, width: 2.0)),
      child: child,
    );
  }
}
