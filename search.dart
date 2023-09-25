//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'home.dart';
import 'add.dart';
import 'notification_screen.dart';
import 'profile.dart';
import 'post_list.dart';
import 'package:collab/shared/bottom_navigation_bar.dart';
import 'package:collab/services/database.dart';
import 'package:collab/models/post.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  int _selectedIndex = 1;

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
              'Search',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.black,
            elevation: 0.0,
            actions: [
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  // TODO: Implement filtering functionality
                },
              ),
            ],
          ),
          body: PostList(),
          bottomNavigationBar: buildBottomNavigation(
              _selectedIndex, _onItemTapped),
        )
    );
  }
}

