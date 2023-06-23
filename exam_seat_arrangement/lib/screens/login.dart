import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultButton.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = false;

  _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
                      child: Column(
                    children: [
                      DefaultTextFormField(
                        obscureText: _obscureText,
                        fontSize: 20.0,
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 25.0),
                      DefaultTextFormField(
                        obscureText: _obscureText,
                        fontSize: 20.0,
                        icon: Icons.lock,
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
                            Navigator.popAndPushNamed(
                                context, '/examOfficerNavbar');
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
                            text: "Don't have an account? ",
                            weight: FontWeight.normal,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: DefaultText(
                                size: 18.0,
                                color: Constants.primaryColor,
                                text: "Register Now",
                                weight: FontWeight.bold,
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
