import 'package:exam_seat_arrangement/models/courses_responses.dart';
import 'package:exam_seat_arrangement/models/create_hall_response.dart';
import 'package:exam_seat_arrangement/models/halls_response.dart';
import 'package:exam_seat_arrangement/services/remote_services.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultButton.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultDropDown.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController _date = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _obscureText = true;
  late String _oldPass, _newPass, _conPass;

  TextEditingController _newP = new TextEditingController();

  _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _submit(context) async {
    var isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();

    await RemoteServices.passwordChange(context, _oldPass, _newPass, _conPass);
    // Navigator.pop(context);
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
                      text: "CHANGE PASSWORD",
                      size: 20.0,
                      color: Constants.primaryColor,
                    )
                  ],
                ),
                const SizedBox(height: 40.0),
                Form(
                    key: _form,
                    child: Column(
                      children: [
                        DefaultTextFormField(
                          obscureText: _obscureText,
                          fontSize: 20.0,
                          label: "Old Password",
                          icon: Icons.lock,
                          maxLines: 1,
                          validator: Constants.validator,
                          onSaved: (value) => _oldPass = value!,
                          suffixIcon: GestureDetector(
                              onTap: () {
                                _toggle();
                              },
                              child: Icon(_obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility)),
                        ),
                        const SizedBox(height: 20.0),
                        DefaultTextFormField(
                          text: _newP,
                          obscureText: _obscureText,
                          fontSize: 20.0,
                          label: "New Password",
                          icon: Icons.lock,
                          maxLines: 1,
                          validator: Constants.validator,
                          onSaved: (value) => _newPass = value!,
                          suffixIcon: GestureDetector(
                              onTap: () {
                                _toggle();
                              },
                              child: Icon(_obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility)),
                        ),
                        const SizedBox(height: 20.0),
                        DefaultTextFormField(
                          obscureText: _obscureText,
                          fontSize: 20.0,
                          label: "Confirm Password",
                          icon: Icons.lock,
                          maxLines: 1,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "This Field is required";
                            }
                            if (value != _newP.text) {
                              return "Password does not match";
                            }
                            return null;
                          },
                          onSaved: (value) => _conPass = value!,
                          suffixIcon: GestureDetector(
                              onTap: () {
                                _toggle();
                              },
                              child: Icon(_obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility)),
                        ),
                        const SizedBox(height: 70.0),
                        SizedBox(
                          width: size.width,
                          child: DefaultButton(
                              onPressed: () {
                                _submit(context);
                              },
                              text: "Change Password",
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
