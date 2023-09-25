//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:collab/screens/wrapper.dart';
import 'package:collab/shared/logo_style.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      // Navigating to the next screen after 5 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Wrapper()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height, // Set container height to the screen height
            child: Column(
              children: [
                // App name in the middle of the screen
                Expanded(
                  child: Center(
                    child: Text(
                      'COLLAB',
                      style: logoTextStyle.copyWith(fontSize: 72),
                    ),
                  ),
                ),
                // App version
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 100),
                  child: Text(
                    'Version: 1.0',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
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