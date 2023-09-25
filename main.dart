//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:collab/services/auth.dart';
import 'package:collab/models/users.dart';
import 'package:collab/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Users?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        home: WelcomeScreen(),
      ),
    );
  }
}


