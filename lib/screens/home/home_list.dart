//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collab/models/post.dart';
import 'package:collab/models/users.dart';
import 'home_tile.dart';
import 'package:collab/services/database.dart';

class HomeList extends StatefulWidget {
  const HomeList({Key? key}) : super(key: key);

  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<Users>(context);
    final posts = Provider.of<List<Post>>(context) ?? [];

    final filteredPosts = posts.where((post) => post.availableSlot > 0 && !post.requestingUser.contains(user.uid) && !post.approvedUser.contains(user.uid) && post.status == "ongoing").toList();

    //Sort the order of the list
    final sortedPosts = filteredPosts.toList()
      ..sort((a, b) => int.parse(b.id).compareTo(int.parse(a.id)));

    return ListView.builder(
      itemCount: sortedPosts.length,
      itemBuilder: (BuildContext context, int index) {
        final post = sortedPosts[index];

        return FutureBuilder<UserData>(
          future: DatabaseService(uid: post.userUID).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!;
              return HomeTile(post: post, userData: userData, user: user);
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Container();
            } else {
              // Data is still loading
              return Container();
            }
          },
        );
      },
    );
  }
}