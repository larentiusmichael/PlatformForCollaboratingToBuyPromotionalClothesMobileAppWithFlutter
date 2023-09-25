//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'package:collab/models/post.dart';
import 'product_detail.dart';
import 'package:collab/models/users.dart';

class HomeTile extends StatelessWidget {
  final Post post;
  final UserData userData;
  final Users user;

  const HomeTile({Key? key, required this.post, required this.userData, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(userData?.profilePicture ?? ''),
                ),
                SizedBox(width: 8),
                Text(
                  userData?.fullName ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.0, // Adjust this value to control image aspect ratio
                child: Image.network(
                  post.postURL,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8.0,
                right: 8.0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: post.online ? Colors.blue[800] : Colors.green,
                  ),
                  child: Text(
                    post.online ? 'ONLINE' : 'ONSITE',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8.0, // Adjust the spacing between categories
                  runSpacing: 8.0, // Adjust the spacing between lines
                  children: post.category.map((category) => Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  )).toList(),
                ),
                SizedBox(height: 10),
                Text(
                  post.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  post.description,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity, // Stretch from left to right
                  padding: EdgeInsets.symmetric(horizontal: 8.0), // Add desired horizontal padding
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(post: post, userData: userData, user: user),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    child: Text(
                      'See Details',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
