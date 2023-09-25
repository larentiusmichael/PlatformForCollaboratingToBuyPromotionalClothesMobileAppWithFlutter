//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'package:collab/services/auth.dart';
import 'package:collab/services/database.dart';
import 'package:provider/provider.dart';
import 'package:collab/shared/logo_style.dart';
import 'package:collab/shared/bottom_navigation_bar.dart';
import 'search.dart';
import 'add.dart';
import 'notification_screen.dart';
import 'profile.dart';
import 'package:collab/screens/wrapper.dart';
import 'package:collab/models/post.dart';
import 'home_list.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Home(),
    Search(),
    Add(),
    NotificationScreen(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => _screens[index],
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Wrapper(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return StreamProvider<List<Post>>.value(
        initialData: [],
        value: DatabaseService().post,
        catchError: (context, error) {
          // Handle the error here
          print('Error occurred: $error');
          // Return a fallback value or rethrow the error if necessary
          return [];
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'COLLAB',
              style: logoTextStyle.copyWith(fontSize: 24),
            ),
            backgroundColor: Colors.black,
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  signOut();
                },
              ),
              IconButton(
                icon: Icon(Icons.message),
                onPressed: () {
                  // TODO: Implement direct messages functionality
                },
              ),
            ],
          ),
          body: HomeList(),
          bottomNavigationBar: buildBottomNavigation(
              _selectedIndex, _onItemTapped),
        )
    );
  }
}