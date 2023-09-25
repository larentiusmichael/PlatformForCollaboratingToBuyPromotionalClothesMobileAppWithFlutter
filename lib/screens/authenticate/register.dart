//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'package:collab/services/auth.dart';
import 'package:collab/shared/input_decoration.dart';
import 'package:collab/shared/loading.dart';
import 'package:flutter/gestures.dart';
import 'package:collab/shared/logo_style.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  //text field state
  String email = "";
  String password = "";
  String confirmPassword = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {

    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height, // Set container height to the screen height
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'COLLAB',
                        style: logoTextStyle,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        child: TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        child: TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        child: TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => confirmPassword = val);
                          },
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        child: FractionallySizedBox(
                          widthFactor: 1.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.pink[400], // Set the desired button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                loading = true;
                                error = ''; // Clear any previous error message
                              });
                              if (email.isEmpty) {
                                setState(() {
                                  error = 'Enter an email';
                                  loading = false;
                                });
                                return;
                              }
                              if (password.length < 6) {
                                setState(() {
                                  error = 'Enter a password with 6+ characters long';
                                  loading = false;
                                });
                                return;
                              }
                              if (confirmPassword.isEmpty) {
                                setState(() {
                                  error = 'Please confirm your password';
                                  loading = false;
                                });
                                return;
                              }
                              if (confirmPassword != password) {
                                setState(() {
                                  error = 'Passwords do not match';
                                  loading = false;
                                });
                                return;
                              }
                              dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  error = 'Could not register with those credentials';
                                  loading = false;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      SizedBox(height: 20.0),
                      RichText(
                        text: TextSpan(
                          text: 'By signing up, you agree to our',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Terms & Privacy Policy.',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.black,
                    padding: EdgeInsets.only(top: 20.0, bottom: 35.0),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Click here to sign in',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  widget.toggleView();
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}