import 'package:exam_seat_arrangement/services/remote_services.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultButton.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  final _form = GlobalKey<FormState>();
  late String _username;
  late String _password;

  _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _login() async {
    var isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();

    await RemoteServices.login(context, _username.toUpperCase(), _password);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.splashBackColor,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo.png",
                      width: 200.0, height: 200.0),
                  const SizedBox(height: 20.0),
                  Form(
                      key: _form,
                      child: Column(
                        children: [
                          DefaultTextFormField(
                            label: "Username",
                            obscureText: false,
                            fontSize: 20.0,
                            icon: Icons.person,
                            fillColor: Colors.white,
                            onSaved: (value) => _username = value!,
                            validator: Constants.validator,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 25.0),
                          DefaultTextFormField(
                            label: "Password",
                            obscureText: _obscureText,
                            fontSize: 20.0,
                            icon: Icons.lock,
                            fillColor: Colors.white,
                            maxLines: 1,
                            onSaved: (value) => _password = value!,
                            validator: Constants.validator,
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  _toggle();
                                },
                                child: Icon(_obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility)),
                          ),
                          const SizedBox(height: 20.0),
                          const SizedBox(height: 20.0),
                          SizedBox(
                            width: size.width,
                            child: DefaultButton(
                              onPressed: () {
                                _login();
                              },
                              text: 'Login',
                              textSize: 22.0,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const DefaultText(
                                size: 18.0,
                                text: "Having trouble logging in? ",
                                weight: FontWeight.normal,
                                align: TextAlign.center,
                                color: Constants.primaryColor,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.pushNamed(context, '/register');
                                  },
                                  child: DefaultText(
                                    size: 18.0,
                                    color: Constants.pillColor,
                                    text: "Contact Exam Officer",
                                    weight: FontWeight.bold,
                                    align: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
