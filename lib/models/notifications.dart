//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

class Notifications {
  final String id;
  final String message;
  final String postID;
  final String ownerUID;
  final String applicantUID;
  final int requestedSpot;
  final bool buttonVisibility;
  final bool readyToGo;

  Notifications({required this.id, required this.message, required this.postID,
    required this.ownerUID, required this.applicantUID, required this.requestedSpot, required this.buttonVisibility, required this.readyToGo});
}