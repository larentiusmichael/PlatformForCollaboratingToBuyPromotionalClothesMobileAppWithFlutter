//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'package:collab/models/post.dart';
import 'package:geocoding/geocoding.dart';
import 'package:collab/models/users.dart';
import 'package:intl/intl.dart';
import 'package:collab/services/database.dart';

class ProductDetailsPage extends StatefulWidget {
  final Post post;
  final UserData userData;
  final Users user;

  ProductDetailsPage({required this.post, required this.userData, required this.user});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {

  void joinAction(int requestedSpot) async {

    String message = '';

    if(widget.post.distributedPrice) {
      message = 'is requesting to join slot ${requestedSpot + 1} in your promotion.';
    } else {
      message = 'is requesting to join in your promotion.';
    }

    List<String> requestingUser = List<String>.from(widget.post.requestingUser);
    requestingUser.add(widget.user.uid);

    await DatabaseService(uid: widget.userData.uid).updatePost2(
        widget.post.id, widget.post.name, widget.post.description, widget.post.selectedCollaborators, widget.post.prices, widget.post.category, widget.post.postURL, widget.post.spot, widget.post.availableSlot,
        widget.post.latitude, widget.post.longitude, widget.post.shopName, widget.post.platformName, widget.post.locationDetail, widget.post.distributedPrice, widget.post.online,
        widget.post.participation, widget.post.creationDate, requestingUser, widget.post.approvedUser, widget.post.status
    );

    await DatabaseService(uid: widget.user.uid).updateNotification(
        message, widget.post.id,
        widget.userData.uid, requestedSpot, true, false
    );
  }

  Future<String> getPlaceName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String placeName = '${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
        return placeName;
      }
    } catch (e) {
      print('Error: $e');
    }
    return 'Unknown';
  }

  void _showConfirmationDialog(int emptyIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to join?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                joinAction(emptyIndex);
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Pop back to the previous screen
              },
              child: Text('Join'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.post.creationDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Promotion Details'),
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.0, // Adjust this value to control image aspect ratio
              child: Image.network(
                widget.post.postURL,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Row(
                    children: [
                      if (widget.post.online == false)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'ONSITE',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      if (widget.post.online == true)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[800],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'ONLINE',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      SizedBox(width: 8),
                      ...widget.post.category.map((category) => Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.only(right: 8.0),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      )).toList(),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.post.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${widget.post.description}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    color: Colors.red,
                    padding: EdgeInsets.all(8.0), // Add desired margin value
                    child: Text(
                      'AVAILABLE SLOT: ${widget.post.availableSlot}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Expected Number of Collaborators: ${widget.post.selectedCollaborators}',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (!widget.post.online)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shop Name: ${widget.post.shopName}',
                          style: TextStyle(fontSize: 16),
                        ),
                        FutureBuilder<String>(
                          future: getPlaceName(widget.post.latitude, widget.post.longitude),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasData) {
                              return Text(
                                'Location: ${snapshot.data}',
                                style: TextStyle(fontSize: 16),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                'Error: ${snapshot.error}',
                                style: TextStyle(fontSize: 16),
                              );
                            } else {
                              return Text(
                                'Location: Unknown',
                                style: TextStyle(fontSize: 16),
                              );
                            }
                          },
                        ),
                        Text(
                          'Location Details: ${widget.post.locationDetail}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  if (widget.post.online)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shop Name: ${widget.post.shopName}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Platform: ${widget.post.platformName}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.userData?.profilePicture ?? ''),
                        radius: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        widget.userData?.fullName ?? '',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                  if (widget.post.distributedPrice)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DataTable(
                          columns: [
                            DataColumn(label: Text('Collaborator')),
                            DataColumn(label: Text('Price')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: List<DataRow>.generate(widget.post.prices.length, (index) {
                            final price = widget.post.prices[index];
                            final spotValue = widget.post.spot[index];

                            // Check if widget.user.UID is not the same as widget.post.userUID
                            bool isDifferentUser = widget.user.uid != widget.post.userUID;

                            return DataRow(
                              cells: [
                                DataCell(Text('${index + 1}')),
                                DataCell(Text(price.toString())),
                                DataCell(
                                  Visibility(
                                    visible: isDifferentUser,
                                    child: ElevatedButton(
                                      onPressed: spotValue.isEmpty
                                          ? () => _showConfirmationDialog(index)
                                          : null,
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                          spotValue.isEmpty ? Colors.black : Colors.grey,
                                        ),
                                      ),
                                      child: Text(
                                        spotValue.isEmpty ? 'Join' : 'Taken',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  SizedBox(height: 16),
                  if (!widget.post.distributedPrice)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Visibility(
                            visible: widget.user.uid != widget.post.userUID,
                            child: ElevatedButton(
                              onPressed: () {
                                int emptyIndex = widget.post.spot.indexWhere((element) => element.isEmpty);
                                if (emptyIndex != -1) {
                                  _showConfirmationDialog(emptyIndex);
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black,
                                ),
                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(horizontal: 16.0),
                                ),
                              ),
                              child: Text(
                                'Join',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}