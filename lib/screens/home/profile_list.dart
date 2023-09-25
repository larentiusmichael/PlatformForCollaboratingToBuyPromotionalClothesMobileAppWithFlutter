//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'package:collab/services/database.dart';
import 'package:provider/provider.dart';
import 'package:collab/models/post.dart';
import 'package:collab/models/users.dart';
import 'profile_tile_detail.dart';


class ProfileList extends StatefulWidget {
  ProfileList({Key? key}) : super(key: key);

  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<Users>(context);
    final posts = Provider.of<List<Post>>(context) ?? [];

    //Reverse the order of the list
    final sortedPosts = posts.toList()
      ..sort((a, b) => int.parse(b.id).compareTo(int.parse(a.id)));

    final postsTabFilteredPosts = sortedPosts.where((post) => post.userUID == user.uid && post.status == "ongoing").toList();

    final requestingTabFilteredPosts = sortedPosts.where((post) => post.requestingUser.contains(user.uid) && post.status == "ongoing").toList();

    final approvedTabFilteredPosts = sortedPosts.where((post) => post.spot.contains(user.uid) && post.status == "ongoing").toList();

    final completedTabFilteredPosts = sortedPosts
        .where((post) =>
          (post.spot.contains(user.uid) || post.userUID == user.uid) && post.status != "ongoing").toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 35.0, 20.0),
            child: FutureBuilder<UserData>(
              future: DatabaseService(uid: user.uid).userData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userData = snapshot.data!;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(userData.profilePicture),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  userData.fullName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${postsTabFilteredPosts.length}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      postsTabFilteredPosts.length == 1 ? 'Post' : 'Posts',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Container();
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          Divider(),
          DefaultTabController(
            length: 4,
            child: Column(
              children: [
                TabBar(
                  indicatorColor: Colors.black, // Set the color of the selected tab indicator
                  labelColor: Colors.black, // Set the text color for selected tabs
                  unselectedLabelColor: Colors.grey, // Set the text color for unselected tabs
                  tabs: [
                    Tab(
                      icon: Icon(Icons.grid_on), // Icon for the first tab
                    ),
                    Tab(
                      icon: Icon(Icons.hourglass_empty), // Icon for the second tab
                    ),
                    Tab(
                      icon: Icon(Icons.done), // Icon for the third tab
                    ),
                    Tab(
                      icon: Icon(Icons.check_circle), // Icon for the fourth tab
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.8, // Adjust the height as needed
                  child: TabBarView(
                    children: [
                      buildPostsTab(postsTabFilteredPosts, user),
                      buildRequestingTab(requestingTabFilteredPosts, user),
                      buildApprovedTab(approvedTabFilteredPosts, user),
                      buildCompletedCancelledTab(completedTabFilteredPosts, user),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildPostsTab(List<Post> posts, Users user) {
    if (posts.isEmpty) {
      return Center(
        child: Text(
          'No posts available',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Adjust the number of columns as needed
      ),
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        final post = posts[index];

        return FutureBuilder<UserData>(
          future: DatabaseService(uid: post.userUID).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!;
              return GestureDetector(
                onTap: () {
                  // Navigate to the detailed page or show the product details here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileTileDetailPage(post: post, userData: userData, user: user, indicator: true),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(post.postURL),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Container();
            } else {
              // Data is still loading
              return CircularProgressIndicator();
            }
          },
        );
      },
    );
  }

  Widget buildRequestingTab(List<Post> posts, Users user) {
    if (posts.isEmpty) {
      return Center(
        child: Text(
          'No request you have made',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Adjust the number of columns as needed
      ),
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        final post = posts[index];

        return FutureBuilder<UserData>(
          future: DatabaseService(uid: post.userUID).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!;
              return GestureDetector(
                onTap: () {
                  // Navigate to the detailed page or show the product details here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileTileDetailPage(post: post, userData: userData, user: user, indicator: false),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(post.postURL),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Container();
            } else {
              // Data is still loading
              return CircularProgressIndicator();
            }
          },
        );
      },
    );
  }

  Widget buildApprovedTab(List<Post> posts, Users user) {
    if (posts.isEmpty) {
      return Center(
        child: Text(
          'No one has approved you',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Adjust the number of columns as needed
      ),
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        final post = posts[index];

        return FutureBuilder<UserData>(
          future: DatabaseService(uid: post.userUID).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!;
              return GestureDetector(
                onTap: () {
                  // Navigate to the detailed page or show the product details here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileTileDetailPage(post: post, userData: userData, user: user, indicator: false),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(post.postURL),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Container();
            } else {
              // Data is still loading
              return CircularProgressIndicator();
            }
          },
        );
      },
    );
  }

  Widget buildCompletedCancelledTab(List<Post> posts, Users user) {
    if (posts.isEmpty) {
      return Center(
        child: Text(
          'No posts available',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Adjust the number of columns as needed
      ),
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        final post = posts[index];

        return FutureBuilder<UserData>(
          future: DatabaseService(uid: post.userUID).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!;
              return GestureDetector(
                onTap: () {
                  // Navigate to the detailed page or show the product details here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileTileDetailPage(post: post, userData: userData, user: user, indicator: false),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(post.postURL),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Container();
            } else {
              // Data is still loading
              return CircularProgressIndicator();
            }
          },
        );
      },
    );
  }
}