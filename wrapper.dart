//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'package:collab/screens/home/home.dart';
import 'package:collab/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:collab/models/users.dart';
import 'package:collab/services/database.dart';
import 'package:collab/first_comer/flow.dart';
import 'package:collab/shared/loading.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isDataFilled = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);

    //return either Home or Authenticate widget
    if (user == null || user.uid.isEmpty) {
      return Authenticate();
    } else {
      return FutureBuilder<UserData>(
        future: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Data is still loading
            return Loading();
          }
          if (snapshot.hasData) {
            final userData = snapshot.data!;
            if (userData.fullName.isEmpty || userData.profilePicture.isEmpty) {
              return Flows(userData: userData, user: user);
            } else {
              return Home();
            }
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Container();
          } else {
            return Container(); // Handle other states if needed
          }
        },
      );
    }
  }
}
