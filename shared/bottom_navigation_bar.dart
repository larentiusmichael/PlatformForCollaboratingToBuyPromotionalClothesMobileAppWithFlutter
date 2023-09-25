//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';

BottomNavigationBar buildBottomNavigation(int selectedIndex, Function(int) onTap) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: selectedIndex,
    onTap: onTap,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.grey,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_box),
        label: 'Add',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.notifications),
        label: 'Notification',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
  );
}