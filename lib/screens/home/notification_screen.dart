//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'home.dart';
import 'search.dart';
import 'add.dart';
import 'profile.dart';
import 'notification_list.dart';
import 'package:collab/shared/bottom_navigation_bar.dart';
import 'package:collab/services/database.dart';
import 'package:provider/provider.dart';
import 'package:collab/models/notifications.dart';

class NotificationScreen extends StatefulWidget {

  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  int _selectedIndex = 3;

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

  @override
  Widget build(BuildContext context) {

    return StreamProvider<List<Notifications>>.value(
        initialData: [],
        value: DatabaseService().notifications,
        catchError: (context, error) {
          // Handle the error here
          print('Error1 occurred: $error');
          // Return a fallback value or rethrow the error if necessary
          return [];
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0.0,
            title: Text(
              'Notification',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: NotificationList(),
          bottomNavigationBar: buildBottomNavigation(
              _selectedIndex, _onItemTapped),
        )
    );
  }
}