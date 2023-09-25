//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'welcome_message.dart';
import 'fill_fullname.dart';
import 'fill_date_of_birth.dart';
import 'upload_profile_picture.dart';
import 'package:collab/models/users.dart';
import 'package:collab/services/database.dart';
import 'package:collab/screens/home/home.dart';

class Flows extends StatefulWidget {
  final UserData userData;
  final Users user;

  Flows({Key? key, required this.userData, required this.user}) : super(key: key);

  @override
  State<Flows> createState() => _FlowsState();
}

class _FlowsState extends State<Flows> {
  int codeState = 0;

  String fullname = '';
  DateTime selectedDate = DateTime.now();
  String profilePicture = '';

  void toggleView() {
    setState(() => codeState = codeState + 1);
  }

  void setFullname(String newFullname) {
    setState(() => fullname = newFullname);
  }

  void setSelectedDate(DateTime newSelectedDate) {
    setState(() => selectedDate = newSelectedDate);
  }

  void setProfilePicture(String newProfilePicture) {
    setState(() => profilePicture = newProfilePicture);
  }

  Future<void> _updateUserData() async {
    await DatabaseService(uid: widget.user.uid).updateUserData(
      fullname,
      selectedDate,
      widget.userData.accountCreation,
      profilePicture,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (codeState == 0) {
      return WelcomeMessage(toggleView: toggleView);
    } else if(codeState == 1) {
      return FillFullname(toggleView: toggleView, userData: widget.userData, user: widget.user, setFullname: setFullname);
      //return Register(toggleView: toggleView);
    } else if(codeState == 2) {
      return FillDateofBirth(toggleView: toggleView, userData: widget.userData, user: widget.user, setSelectedDate: setSelectedDate);
    } else if(codeState == 3) {
      return UploadProfilePicture(toggleView: toggleView, userData: widget.userData, user: widget.user, setProfilePicture: setProfilePicture);
    } else {
      _updateUserData();
      return Home();
    }
  }
}