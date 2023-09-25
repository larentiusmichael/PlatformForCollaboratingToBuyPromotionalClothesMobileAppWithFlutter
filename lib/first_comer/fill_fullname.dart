//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'package:collab/shared/input_decoration.dart';
import 'package:collab/models/users.dart';

class FillFullname extends StatefulWidget {
  final Function toggleView;
  final UserData userData;
  final Users user;
  final Function setFullname;

  FillFullname({Key? key, required this.toggleView, required this.userData, required this.user, required this.setFullname}) : super(key: key);

  @override
  State<FillFullname> createState() => _FillFullnameState();
}

class _FillFullnameState extends State<FillFullname> {

  String name = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        resizeToAvoidBottomInset: false, // Prevent screen squeezing when keyboard is opened
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height, // Set a fixed height for the container
            padding: EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Form(
                    key: _formKey, // Provide the _formKey
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Please enter your full name:',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.0),
                          child: TextFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Ex: Laurentius Michael',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            maxLength: 23, // Set the maximum length to 23 characters
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              setState(() => name = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.grey[100],
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () async {
                      if(_formKey.currentState?.validate() == true)
                      {
                        widget.setFullname(name);
                        widget.toggleView();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(color: Colors.white),
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