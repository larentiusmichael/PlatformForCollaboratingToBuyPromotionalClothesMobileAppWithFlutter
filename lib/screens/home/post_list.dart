//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collab/models/post.dart';
import 'package:collab/models/users.dart';
import 'post_tile.dart';
import 'package:collab/services/database.dart';

class PostList extends StatefulWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<Users>(context);
    final posts = Provider.of<List<Post>>(context) ?? [];

    // Filter the posts based on the user UID
    final filteredPosts = posts.where((post) => post.userUID != user.uid).toList();

    final filteredPosts2 = filteredPosts.where((post) =>
      post.availableSlot > 0 && !post.requestingUser.contains(user.uid) &&
        !post.approvedUser.contains(user.uid) && post.status == "ongoing").toList();

    //Sort the order of the list in descending order
    final sortedPosts = filteredPosts2.toList()
      ..sort((a, b) => int.parse(b.id).compareTo(int.parse(a.id)));

    return GridView.builder(
      itemCount: sortedPosts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (BuildContext context, int index) {
        final post = sortedPosts[index];

        return FutureBuilder<UserData>(
          future: DatabaseService(uid: post.userUID).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!;
              return PostTile(post: post, userData: userData, user: user);
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