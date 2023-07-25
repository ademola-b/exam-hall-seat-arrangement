import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:flutter/material.dart';

class DefaultTextFormField extends StatefulWidget {
  final String? hintText;
  final double? fontSize;
  final IconData? icon;
  final Widget? suffixIcon;
  final TextEditingController? text;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool? enabled;
  final bool? readOnly;
  final int? maxLines;
  final String? label;
  final Color? fillColor;
  final keyboardInputType;
  final Function()? onTap;

  const DefaultTextFormField(
      {Key? key,
      this.hintText,
      this.text,
      this.icon,
      this.suffixIcon,
      // required this.onSaved,
      this.validator,
      this.keyboardInputType,
      this.maxLines,
      required this.obscureText,
      this.fontSize,
      this.enabled,
      this.label,
      this.onSaved,
      this.fillColor,
      this.onTap,
      this.readOnly})
      : super(key: key);

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      controller: widget.text,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      // readOnly: widget.readOnly!,
      keyboardType: widget.keyboardInputType,
      validator: widget.validator,
      onSaved: widget.onSaved,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.white)),
        enabledBorder: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.white)),

        // fillColor: Colors.white,
        fillColor: widget.fillColor,
        filled: true,
        label: DefaultText(size: 20.0, text: "${widget.label}"),
        labelStyle: const TextStyle(color: Constants.primaryColor),
        iconColor: Constants.primaryColor,
        prefixIcon: Icon(widget.icon),
        prefixIconColor: Constants.primaryColor,
        suffixIcon: widget.suffixIcon,
        // hintText: widget.hintText,
      ),
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: widget.fontSize,
      ),
    );
  }
}
