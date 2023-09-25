//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collab/models/notifications.dart';
import 'package:collab/models/users.dart';
import 'package:collab/models/post.dart';
import 'notification_tile.dart';
import 'package:collab/services/database.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<Users>(context);
    final notifications = Provider.of<List<Notifications>>(context) ?? [];

    // Filter the posts based on the user UID
    final filteredNotif = notifications.where((notif) => notif.ownerUID == user.uid).toList();

    //Sort the order of the list
    final sortedNotif = filteredNotif.toList()
      ..sort((a, b) => int.parse(b.id).compareTo(int.parse(a.id)));

    return ListView.builder(
      itemCount: sortedNotif.length,
      itemBuilder: (BuildContext context, int index) {
        final notif = sortedNotif[index];

        return FutureBuilder<UserData>(
          future: DatabaseService(uid: notif.applicantUID).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!;
              return FutureBuilder<Post>(
                future: DatabaseService(uid: notif.postID).postData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final post = snapshot.data!;
                    return NotificationTile(notification: notif, userData: userData, user: user, post: post);
                  } else if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Container();
                  } else {
                    // Data is still loading
                    return Container();
                  }
                },
              );
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