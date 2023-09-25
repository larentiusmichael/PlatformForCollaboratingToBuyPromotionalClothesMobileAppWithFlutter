//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'package:collab/models/users.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class UploadProfilePicture extends StatefulWidget {
  final Function toggleView;
  final UserData userData;
  final Users user;
  final Function setProfilePicture;

  UploadProfilePicture({Key? key, required this.toggleView, required this.userData, required this.user, required this.setProfilePicture}) : super(key: key);

  @override
  State<UploadProfilePicture> createState() => _UploadProfilePictureState();
}

class _UploadProfilePictureState extends State<UploadProfilePicture> {

  File? selectedImage;

  String? imageError;

  bool isButtonDisabled = false;

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
        imageError = '';
      });
    }
  }

  bool validateImage() {
    if (selectedImage == null) {
      setState(() {
        imageError = 'Please select an image';
      });
      return false;
    }
    return true;
  }

  Future<String?> uploadImageToStorage(File? imageFile) async {
    if (imageFile != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      try {
        // Upload the image to Firebase Storage
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('profile')
            .child(fileName);
        await ref.putFile(imageFile);

        // Get the download URL of the uploaded image
        String imageUrl = await ref.getDownloadURL();
        return imageUrl;

      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
        return null;
      }
    } else {
      setState(() {
        imageError = 'Please select an image';
      });
      return null; // Return null when no image is selected
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        resizeToAvoidBottomInset: false, // Prevent screen squeezing when keyboard is opened
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height, // Set a fixed height for the container
            padding: EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Please upload your profile picture:',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      ClipOval(
                        child: InkWell(
                          onTap: _selectImage,
                          child: Container(
                            height: 300,
                            width: 300,
                            color: Colors.grey[200],
                            child: selectedImage != null
                                ? Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            )
                                : Icon(Icons.camera_alt),
                          ),
                        ),
                      ),
                      if (imageError != null)
                        Text(
                          imageError!,
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.grey[100],
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                  child: ElevatedButton(
                    onPressed: isButtonDisabled ? null : () async {
                      if(validateImage())
                      {
                        setState(() {
                          isButtonDisabled = true; // Disable the button during the ongoing processes
                        });

                        Future<String?> imageURL = uploadImageToStorage(selectedImage);
                        String profilePictureURL = (await imageURL) ?? '';

                        widget.setProfilePicture(profilePictureURL);
                        widget.toggleView();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}