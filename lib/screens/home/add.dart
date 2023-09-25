//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'home.dart';
import 'search.dart';
import 'notification_screen.dart';
import 'profile.dart';
import 'package:collab/shared/bottom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:collab/services/database.dart';
import 'package:collab/models/users.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {

  int _selectedIndex = 2;
  final _formKey = GlobalKey<FormState>();
  String? imageError;
  Location? selectedLocation;
  String? locationError;
  final _locationController = TextEditingController();
  LatLng? _selectedLatLng;

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

  String name = '';
  String description = '';
  int selectedCollaborators = 2; // Default value
  List<double> prices = List<double>.generate(2, (index) => 0.0);
  List<String> spot = List<String>.generate(2, (index) => '');
  List<String> category = [];
  File? selectedImage;
  double latitude = 0.0;
  double longitude = 0.0;
  String shopName = '';
  String platformName = '';
  String locationDetail = '';
  int availableSlot = 2;
  String status = 'ongoing';

  bool distributedPrice = false;
  bool online = false;
  bool participation = false;

  List<String> requestingUser = [];
  List<String> approvedUser = [];

  int selectedSpot = 0;
  bool isButtonDisabled = false;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<List<Location>> _getPlaceSuggestions(String input) async {
    if (input.isNotEmpty) {
      List<Location> locations = await locationFromAddress(input);
      return locations;
    }
    return [];
  }

  Future<void> _getPlaceDetails(Location location) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      location.latitude!,
      location.longitude!,
    );

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      setState(() {
        _selectedLatLng = LatLng(
          location.latitude!,
          location.longitude!,
        );
        latitude = location.latitude!;
        longitude = location.longitude!;
      });
    }
  }

  //List of categories
  List<String> options = ['Male', 'Female', 'Baby & Kids'];

  void toggleOption(String option) {
    setState(() {
      if (category.contains(option)) {
        category.remove(option);
      } else {
        category.add(option);
      }
    });
  }

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
            .child('posts')
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

  bool validateLocation() {
    if (selectedLocation == null) {
      setState(() {
        locationError = 'Please select a location';
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Promotion Upload'),
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Wrap ListView with SingleChildScrollView
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                InkWell(
                  onTap: _selectImage,
                  child: Container(
                    height: 350,
                    width: 350,
                    color: Colors.grey[200],
                    child: selectedImage != null
                        ? Image.file(
                      selectedImage!,
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.camera_alt),
                  ),
                ),
                if (imageError != null)
                  Text(
                    imageError!,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Promotion Name',
                    border: OutlineInputBorder(), // Set border to OutlineInputBorder
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter promotion name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Promotion Description',
                    border: OutlineInputBorder(), // Set border to OutlineInputBorder
                  ),
                  maxLines: null, // Allow unlimited lines of input
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Select number of collaborators',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                DropdownButtonFormField<int>(
                  value: selectedCollaborators,
                  onChanged: (value) {
                    setState(() {
                      selectedCollaborators = value ?? 0;
                      availableSlot = value ?? 0;
                      prices = List<double>.generate(selectedCollaborators, (index) => 0.0);
                      spot = List<String>.generate(selectedCollaborators, (index) => '');
                    });
                  },
                  items: List.generate(
                    9,
                        (index) => DropdownMenuItem<int>(
                      value: index + 2,
                      child: Text('${index + 2} Collaborators'),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Switch(
                      value: distributedPrice,
                      onChanged: (value) {
                        setState(() {
                          distributedPrice = value;
                        });
                      },
                    ),
                    Text(
                      distributedPrice ? 'Set price for each collaborator' : 'Price to be confirmed',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Visibility(
                  visible: distributedPrice,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      Text(
                        'Price for each collaborator',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: selectedCollaborators,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Collaborator ${index + 1} Price (MYR)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allow numbers and a decimal point
                                ],
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please enter price for collaborator ${index + 1}';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  try {
                                    setState(() {
                                      // Handle price changes for each collaborator
                                      prices[index] = double.parse(value) ?? 0.0;
                                    });
                                  } catch(e) {
                                    print(e);
                                  }
                                },
                              ),
                              SizedBox(height: 10.0), // Add a SizedBox below each TextField
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Select category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    String option = options[index];
                    return CheckboxListTile(
                      title: Text(option),
                      value: category.contains(option),
                      onChanged: (value) => toggleOption(option),
                      activeColor: Colors.black,
                    );
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Switch(
                      value: online,
                      onChanged: (value) {
                        setState(() {
                          online = value;
                        });
                      },
                    ),
                    Text(
                      online ? 'Promotion is online' : 'Promotion is onsite',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Visibility(
                  visible: !online,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Shop Name',
                          border: OutlineInputBorder(), // Set border to OutlineInputBorder
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter shop name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            shopName = value;
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      TypeAheadField<Location>(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _locationController,
                          decoration: InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(),
                            errorText: locationError, // Display the error message
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          return await _getPlaceSuggestions(pattern);
                        },
                        itemBuilder: (context, Location suggestion) {
                          return ListTile(
                            title: Text(suggestion.toString()),
                          );
                        },
                        onSuggestionSelected: (Location suggestion) async {
                          setState(() {
                            _locationController.text = suggestion.toString();
                            selectedLocation = suggestion;
                            locationError = ''; // Clear the error message
                          });

                          try {
                            await _getPlaceDetails(suggestion);
                          } catch (e) {
                            print('Error: $e');
                          }
                        },
                        noItemsFoundBuilder: (context) {
                          return ListTile(
                            title: Text('No suggestions found'),
                          );
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Lot No/Address/Surroundings',
                          border: OutlineInputBorder(), // Set border to OutlineInputBorder
                        ),
                        maxLines: null, // Allow unlimited lines of input
                        onChanged: (value) {
                          setState(() {
                            locationDetail = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: online,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Shop Name',
                          border: OutlineInputBorder(), // Set border to OutlineInputBorder
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter shop name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            shopName = value;
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Platform Name',
                          border: OutlineInputBorder(), // Set border to OutlineInputBorder
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter platform name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            platformName = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Will you participate in this promotion?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Switch(
                      value: participation,
                      onChanged: (value) {
                        setState(() {
                          participation = value;
                        });
                      },
                    ),
                    Text(
                      participation ? 'Yes' : 'No',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Visibility(
                  visible: participation && distributedPrice,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      Text(
                        'Choose your collaborator number:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      DropdownButtonFormField<int>(
                        value: 1,
                        onChanged: (value) {
                          setState(() {
                            int index = (value ?? 1) - 1;
                            selectedSpot = index;
                          });
                        },
                        items: List.generate(
                          selectedCollaborators,
                              (index) => DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text('Collaborator ${index + 1}'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 100.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isButtonDisabled ? null : () async {
                          if (validateImage() && _formKey.currentState?.validate() == true) {
                            if(!online) {
                              if(validateLocation()) {
                                setState(() {
                                  isButtonDisabled = true; // Disable the button during the ongoing processes
                                });
                                platformName = '';

                                if(participation) {
                                  availableSlot = availableSlot - 1;
                                  spot = List<String>.generate(
                                    selectedCollaborators,
                                        (i) => i == selectedSpot ? user.uid! : '',
                                  );
                                }
                                if(!participation) {
                                  spot = List<String>.generate(selectedCollaborators, (index) => '');
                                }

                                Future<String?> imageURL = uploadImageToStorage(selectedImage);
                                String postURL = (await imageURL) ?? '';

                                await DatabaseService(uid: user.uid).updatePost(
                                    name, description, selectedCollaborators, prices, category, postURL, spot, availableSlot,
                                    latitude, longitude, shopName, platformName, locationDetail, distributedPrice, online, participation, requestingUser, approvedUser, status
                                );

                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => _screens[0],
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(opacity: animation, child: child);
                                    },
                                  ),
                                );
                              }
                            } else {
                              setState(() {
                                isButtonDisabled = true; // Disable the button during the ongoing processes
                              });
                              latitude = 0.0;
                              longitude = 0.0;
                              locationDetail = '';

                              if(participation) {
                                availableSlot = availableSlot - 1;
                                spot = List<String>.generate(
                                  selectedCollaborators,
                                      (i) => i == selectedSpot ? user.uid! : '',
                                );
                              }
                              if(!participation) {
                                spot = List<String>.generate(selectedCollaborators, (index) => '');
                              }

                              Future<String?> imageURL = uploadImageToStorage(selectedImage);
                              String postURL = (await imageURL) ?? '';

                              await DatabaseService(uid: user.uid).updatePost(
                                  name, description, selectedCollaborators, prices, category, postURL, spot, availableSlot,
                                  latitude, longitude, shopName, platformName, locationDetail, distributedPrice, online, participation, requestingUser, approvedUser, status
                              );

                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => _screens[0],
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(opacity: animation, child: child);
                                  },
                                ),
                              );
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                        child: Text('Upload Promotion'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigation(_selectedIndex, _onItemTapped),
    );
  }
}