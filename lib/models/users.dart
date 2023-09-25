//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

class Users {
  final String uid;

  Users(this.uid);
}

class UserData {
  final String uid;
  final String fullName;
  final DateTime dateOfBirth;
  final DateTime accountCreation;
  final String profilePicture;

  UserData({required this.uid, required this.fullName, required this.dateOfBirth, required this.accountCreation, required this.profilePicture});
}