//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'package:collab/shared/input_decoration.dart';
import 'package:collab/models/users.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class FillDateofBirth extends StatefulWidget {
  final Function toggleView;
  final UserData userData;
  final Users user;
  final Function setSelectedDate;

  FillDateofBirth({Key? key, required this.toggleView, required this.userData, required this.user, required this.setSelectedDate}) : super(key: key);

  @override
  State<FillDateofBirth> createState() => _FillDateofBirthState();
}

class _FillDateofBirthState extends State<FillDateofBirth> {

  DateTime? selectedDate;
  final _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat("yyyy-MM-dd");

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
                          'Please select your date of birth:',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.0),
                          child: DateTimeField(
                            format: dateFormat,
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Ex: 1957-08-31',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onChanged: (date) {
                              setState(() {
                                selectedDate = date;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select your date of birth';
                              }
                              return null;
                            },
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() {
                                  selectedDate = date;
                                });
                                return date;
                              } else {
                                return currentValue;
                              }
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
                      if(_formKey.currentState?.validate() == true) {
                        widget.setSelectedDate(selectedDate);
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