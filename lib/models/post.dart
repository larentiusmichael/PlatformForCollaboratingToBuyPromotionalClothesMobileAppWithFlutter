//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

class Post {
  final String id;
  final String name;
  final String description;
  final int selectedCollaborators;
  final List<double> prices;
  final List<String> category;
  final String postURL;
  final List<String> spot;
  final int availableSlot;
  final double latitude;
  final double longitude;
  final String shopName;
  final String platformName;
  final String locationDetail;
  final bool distributedPrice;
  final bool online;
  final bool participation;
  final DateTime creationDate;
  final String userUID;
  final List<String> requestingUser;
  final List<String> approvedUser;
  final String status;

  Post({required this.id, required this.name, required this.description, required this.selectedCollaborators, required this.prices,
    required this.category, required this.postURL, required this.spot,  required this.availableSlot,  required this.latitude,
    required this.longitude,  required this.shopName,  required this.platformName,  required this.locationDetail,
    required this.distributedPrice, required this.online, required this.participation, required this.creationDate, required this.userUID,
    required this.requestingUser, required this.approvedUser, required this.status});
}

