//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'package:collab/models/post.dart';
import 'package:collab/models/notifications.dart';
import 'notification_product_detail.dart';
import 'package:collab/models/users.dart';
import 'package:collab/services/database.dart';

class NotificationTile extends StatefulWidget {
  final Notifications notification;
  final UserData userData;
  final Users user;
  final Post post;

  const NotificationTile({Key? key, required this.notification, required this.userData, required this.user, required this.post}) : super(key: key);

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {

  @override
  Widget build(BuildContext context) {
    bool isApproved = widget.post.spot.contains(widget.notification.applicantUID);

    void action() async {

      if(isApproved) {
        int availableSlot = widget.post.availableSlot;

        if(availableSlot > 0) {
          List<String> spot = List<String>.from(widget.post.spot);
          spot[widget.notification.requestedSpot] = widget.notification.applicantUID;

          availableSlot = availableSlot - 1;

          int requestedSpot = widget.notification.requestedSpot;

          //if availableSlot already 0, create notification for the owner of the promotion as the promotion ready to be executed
          String notice = '';

          if(availableSlot == 0) {
            notice = 'This promotion has reached the expected number of collaborators.';

            await DatabaseService(uid: widget.notification.applicantUID).updateNotification(
                notice, widget.notification.postID,
                widget.notification.ownerUID, requestedSpot, false, true
            );
          }

          String message = '';

          if(widget.post.distributedPrice) {
            message = 'has approved you to join slot ${requestedSpot + 1} in this promotion.';
          } else {
            message = 'has approved you to join this promotion.';
          }

          List<String> requestingUser = List<String>.from(widget.post.requestingUser);
          if (requestingUser.contains(widget.notification.applicantUID)) {
            requestingUser.remove(widget.notification.applicantUID);
          }

          List<String> approvedUser = List<String>.from(widget.post.approvedUser);
          approvedUser.add(widget.notification.applicantUID);

          await DatabaseService(uid: widget.user.uid).updatePost2(
              widget.post.id, widget.post.name, widget.post.description, widget.post.selectedCollaborators, widget.post.prices, widget.post.category, widget.post.postURL, spot, availableSlot,
              widget.post.latitude, widget.post.longitude, widget.post.shopName, widget.post.platformName, widget.post.locationDetail, widget.post.distributedPrice, widget.post.online,
              widget.post.participation, widget.post.creationDate, requestingUser, approvedUser, widget.post.status
          );

          await DatabaseService(uid: widget.user.uid).updateNotification(
              message, widget.notification.postID,
              widget.notification.applicantUID, requestedSpot, false, false
          );
        } else {
          int requestedSpot = widget.notification.requestedSpot;

          String notice = 'This promotion cannot add more collaborator.';

          await DatabaseService(uid: widget.notification.applicantUID).updateNotification(
              notice, widget.notification.postID,
              widget.notification.ownerUID, requestedSpot, false, true
          );
        }
      } else {
        bool checking = widget.post.spot.contains(widget.notification.applicantUID);

        if(checking) {
          List<String> spot = List<String>.from(widget.post.spot);
          spot[widget.notification.requestedSpot] = '';

          int availableSlot = widget.post.availableSlot;
          availableSlot = availableSlot + 1;

          int requestedSpot = widget.notification.requestedSpot;

          String message = '';

          if(widget.post.distributedPrice) {
            message = 'has rejected you to join slot ${requestedSpot + 1} in this promotion.';
          } else {
            message = 'has rejected you to join this promotion.';
          }

          List<String> requestingUser = List<String>.from(widget.post.requestingUser);
          requestingUser.add(widget.notification.applicantUID);

          List<String> approvedUser = List<String>.from(widget.post.approvedUser);
          if (approvedUser.contains(widget.notification.applicantUID)) {
            approvedUser.remove(widget.notification.applicantUID);
          }

          await DatabaseService(uid: widget.user.uid).updatePost2(
              widget.post.id, widget.post.name, widget.post.description, widget.post.selectedCollaborators, widget.post.prices, widget.post.category, widget.post.postURL, spot, availableSlot,
              widget.post.latitude, widget.post.longitude, widget.post.shopName, widget.post.platformName, widget.post.locationDetail, widget.post.distributedPrice, widget.post.online,
              widget.post.participation, widget.post.creationDate, requestingUser, approvedUser, widget.post.status
          );

          await DatabaseService(uid: widget.user.uid).updateNotification(
              message, widget.notification.postID,
              widget.notification.applicantUID, requestedSpot, false, false
          );
        } else {
          int requestedSpot = widget.notification.requestedSpot;

          String message = '';

          if(widget.post.distributedPrice) {
            message = 'has rejected you to join slot ${requestedSpot + 1} in this promotion.';
          } else {
            message = 'has rejected you to join this promotion.';
          }

          await DatabaseService(uid: widget.user.uid).updateNotification(
              message, widget.notification.postID,
              widget.notification.applicantUID, requestedSpot, false, false
          );
        }
      }
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Visibility(
                  visible: !widget.notification.readyToGo,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(widget.userData?.profilePicture ?? ''),
                      ),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userData?.fullName ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.notification.message,
                            style: TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.notification.readyToGo,
                  child: Text(
                    widget.notification.message,
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ),
                Spacer(), // Add a spacer to push the button and image to the right end
                Visibility(
                  visible: widget.notification.buttonVisibility,
                  child: ElevatedButton(
                    onPressed: ()  {
                      setState(() {
                        isApproved = !isApproved;
                        action();
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        isApproved ? Colors.grey : Colors.black,
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(Size(45, 25)),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                    ),
                    child: Text(
                      isApproved ? 'Reject' : 'Approve',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationProductPage(post: widget.post, userData: widget.userData, user: widget.user, notification: widget.notification),
                      ),
                    );
                  },
                  child: Image.network(
                    widget.post.postURL,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
