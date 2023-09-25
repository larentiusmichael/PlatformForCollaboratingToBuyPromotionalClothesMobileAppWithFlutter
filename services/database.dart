//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/models/users.dart';
import 'package:collab/models/post.dart';
import 'package:collab/models/notifications.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid = ''});

  //collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('USER_T');
  final CollectionReference postCollection = FirebaseFirestore.instance.collection('POST_T');
  final CollectionReference notificationCollection = FirebaseFirestore.instance.collection('NOTIFICATION_T');

  //count the number of data in the dataset/collection
  Future<int> getPostCollectionCount() async {
    QuerySnapshot snapshot = await postCollection.get();
    return snapshot.size;
  }

  Future<int> getNotificationCollectionCount() async {
    QuerySnapshot snapshot = await notificationCollection.get();
    return snapshot.size;
  }

  Future updateUserData(String fullName, DateTime dateOfBirth, DateTime accountCreation, String profilePicture) async {
    return await userCollection.doc(uid).set({
      'user_fullname': fullName,
      'user_date_of_birth': dateOfBirth,
      'user_account_creation': accountCreation,
      'user_profile_picture': profilePicture,
    });
  }

  Future updatePost(String name, String description, int selectedCollaborators, List<double> prices, List<String> category, String postURL, List<String> spot, int availableSlot, double latitude, double longitude, String shopName, String platformName, String locationDetail, bool distributedPrice, bool online, bool participation, List<String> requestingUser, List<String> approvedUser, String status) async {
    Future<int> index = getPostCollectionCount();
    int count = await index;
    int newIndex = count + 1;
    return await postCollection.doc(newIndex.toString()).set({
      'post_id': newIndex.toString(),
      'post_name': name,
      'post_description': description,
      'post_number_collaborators': selectedCollaborators,
      'post_prices': prices,
      'post_category': category,
      'post_image_url': postURL,
      'post_spot': spot,
      'post_available_slot': availableSlot,
      'post_latitude': latitude,
      'post_longitude': longitude,
      'post_shop_name': shopName,
      'post_platform_name': platformName,
      'post_location_detail': locationDetail,
      'post_distributed_price': distributedPrice,
      'post_online': online,
      'post_participation': participation,
      'post_creation_date': DateTime.now(),
      'post_user_uid': uid,
      'post_requesting_user': requestingUser,
      'post_approved_user': approvedUser,
      'post_status': status,
    });
  }

  Future updatePost2(String id, String name, String description, int selectedCollaborators, List<double> prices, List<String> category, String postURL, List<String> spot, int availableSlot, double latitude, double longitude, String shopName, String platformName, String locationDetail, bool distributedPrice, bool online, bool participation, DateTime creationDate, List<String> requestingUser, List<String> approvedUser, String status) async {
    return await postCollection.doc(id).set({
      'post_id': id,
      'post_name': name,
      'post_description': description,
      'post_number_collaborators': selectedCollaborators,
      'post_prices': prices,
      'post_category': category,
      'post_image_url': postURL,
      'post_spot': spot,
      'post_available_slot': availableSlot,
      'post_latitude': latitude,
      'post_longitude': longitude,
      'post_shop_name': shopName,
      'post_platform_name': platformName,
      'post_location_detail': locationDetail,
      'post_distributed_price': distributedPrice,
      'post_online': online,
      'post_participation': participation,
      'post_creation_date': creationDate,
      'post_user_uid': uid,
      'post_requesting_user': requestingUser,
      'post_approved_user': approvedUser,
      'post_status': status,
    });
  }

  Future updateNotification(String message, String postID, String ownerUID, int requestedSpot, bool buttonVisibility, bool readyToGo) async {
    Future<int> index = getNotificationCollectionCount();
    int count = await index;
    int newIndex = count + 1;
    return await notificationCollection.doc(newIndex.toString()).set({
      'notif_id': newIndex.toString(),
      'notif_message': message,
      'notif_post_id': postID,
      'notif_owner_uid': ownerUID,
      'notif_applicant_uid': uid,
      'notif_requested_spot': requestedSpot,
      'notif_button_visibility': buttonVisibility,
      'notif_ready_to_go': readyToGo,
    });
  }

  //post list from snapshot
  List<Post> _postListFromSnapshot(QuerySnapshot<Object?> snapshot) {
    return snapshot.docs.map((doc) {
      List<dynamic>? pricesData = (doc.data() as Map<String, dynamic>)['post_prices'];
      List<double> prices = pricesData?.map<double>((price) => price.toDouble()).toList() ?? [];

      List<dynamic>? categoryData = (doc.data() as Map<String, dynamic>)['post_category'];
      List<String> category = categoryData?.map<String>((cat) => cat.toString()).toList() ?? [];

      List<dynamic>? spotData = (doc.data() as Map<String, dynamic>)['post_spot'];
      List<String> spot = spotData?.map<String>((spt) => spt.toString()).toList() ?? [];

      List<dynamic>? requestingUserData = (doc.data() as Map<String, dynamic>)['post_requesting_user'];
      List<String> requestingUser = requestingUserData?.map<String>((rqu) => rqu.toString()).toList() ?? [];

      List<dynamic>? approvedUserData = (doc.data() as Map<String, dynamic>)['post_approved_user'];
      List<String> approvedUser = approvedUserData?.map<String>((apu) => apu.toString()).toList() ?? [];

      return Post(
        id: (doc.data() as Map<String, dynamic>)['post_id'] ?? '',
        name: (doc.data() as Map<String, dynamic>)['post_name'] ?? '',
        description: (doc.data() as Map<String, dynamic>)['post_description'] ?? '',
        selectedCollaborators: (doc.data() as Map<String, dynamic>)['post_number_collaborators'] ?? 2,
        prices: prices,
        category: category,
        postURL: (doc.data() as Map<String, dynamic>)['post_image_url'] ?? '',
        spot: spot,
        availableSlot: (doc.data() as Map<String, dynamic>)['post_available_slot'] ?? 2,
        latitude: (doc.data() as Map<String, dynamic>)['post_latitude'] ?? 0.0,
        longitude: (doc.data() as Map<String, dynamic>)['post_longitude'] ?? 0.0,
        shopName: (doc.data() as Map<String, dynamic>)['post_shop_name'] ?? '',
        platformName: (doc.data() as Map<String, dynamic>)['post_platform_name'] ?? '',
        locationDetail: (doc.data() as Map<String, dynamic>)['post_location_detail'] ?? '',
        distributedPrice: (doc.data() as Map<String, dynamic>)['post_distributed_price'] ?? false,
        online: (doc.data() as Map<String, dynamic>)['post_online'] ?? false,
        participation: (doc.data() as Map<String, dynamic>)['post_participation'] ?? false,
        creationDate: (doc.data() as Map<String, dynamic>)['post_creation_date'] != null ? (doc.data() as Map<String, dynamic>)['post_creation_date'].toDate() : DateTime.now(),
        userUID: (doc.data() as Map<String, dynamic>)['post_user_uid'] ?? '',
        requestingUser: requestingUser,
        approvedUser: approvedUser,
        status: (doc.data() as Map<String, dynamic>)['post_status'] ?? '',
      );
    }).toList();
  }

  //post data from snapshot
  Future<Post> get postData async {
    final snapshot = await postCollection.doc(uid).get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;

      List<dynamic>? pricesData = data['post_prices'];
      List<double> prices = pricesData?.map<double>((price) => price.toDouble()).toList() ?? [];

      List<dynamic>? categoryData = data['post_category'];
      List<String> category = categoryData?.map<String>((cat) => cat.toString()).toList() ?? [];

      List<dynamic>? spotData = data['post_spot'];
      List<String> spot = spotData?.map<String>((spt) => spt.toString()).toList() ?? [];

      List<dynamic>? requestingUserData = data['post_requesting_user'];
      List<String> requestingUser = requestingUserData?.map<String>((rqu) => rqu.toString()).toList() ?? [];

      List<dynamic>? approvedUserData = data['post_approved_user'];
      List<String> approvedUser = approvedUserData?.map<String>((apu) => apu.toString()).toList() ?? [];

      return Post(
        id: data['post_id'] ?? '',
        name: data['post_name'] ?? '',
        description: data['post_description'] ?? '',
        selectedCollaborators: data['post_number_collaborators'] ?? 2,
        prices: prices,
        category: category,
        postURL: data['post_image_url'] ?? '',
        spot: spot,
        availableSlot: data['post_available_slot'] ?? 2,
        latitude: data['post_latitude'] ?? 0.0,
        longitude: data['post_longitude'] ?? 0.0,
        shopName: data['post_shop_name'] ?? '',
        platformName: data['post_platform_name'] ?? '',
        locationDetail: data['post_location_detail'] ?? '',
        distributedPrice: data['post_distributed_price'] ?? false,
        online: data['post_online'] ?? false,
        participation: data['post_participation'] ?? false,
        creationDate: data['post_creation_date'] != null ? data['post_creation_date'].toDate() : DateTime.now(),
        userUID: data['post_user_uid'] ?? '',
        requestingUser: requestingUser,
        approvedUser: approvedUser,
        status: data['post_status'] ?? '',
      );
    } else {
      return Post(
        id: '',
        name: '',
        description: '',
        selectedCollaborators: 2,
        prices: [],
        category: [],
        postURL: '',
        spot: [],
        availableSlot: 2,
        latitude: 0.0,
        longitude: 0.0,
        shopName: '',
        platformName: '',
        locationDetail: '',
        distributedPrice: false,
        online: false,
        participation: false,
        creationDate: DateTime.now(),
        userUID: '',
        requestingUser: [],
        approvedUser: [],
        status: '',
      );
    }
  }

  //user data from snapshot
  Future<UserData> get userData async {
    final snapshot = await userCollection.doc(uid).get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;

      return UserData(
        uid: uid,
        fullName: data['user_fullname'] ?? '',
        dateOfBirth: (data['user_date_of_birth'] as Timestamp).toDate(),
        accountCreation: (data['user_account_creation'] as Timestamp).toDate(),
        profilePicture: data['user_profile_picture'] ?? '',
      );
    } else {
      return UserData(
        uid: uid,
        fullName: '',
        dateOfBirth: DateTime.now(),
        accountCreation: DateTime.now(),
        profilePicture: '',
      );
    }
  }

  //notification list from snapshot
  List<Notifications> _notificationListFromSnapshot(QuerySnapshot<Object?> snapshot) {
    return snapshot.docs.map((doc) {
      return Notifications(
        id: (doc.data() as Map<String, dynamic>)['notif_id'] ?? '',
        message: (doc.data() as Map<String, dynamic>)['notif_message'] ?? '',
        postID: (doc.data() as Map<String, dynamic>)['notif_post_id'] ?? '',
        ownerUID: (doc.data() as Map<String, dynamic>)['notif_owner_uid'] ?? '',
        applicantUID: (doc.data() as Map<String, dynamic>)['notif_applicant_uid'] ?? '',
        requestedSpot: (doc.data() as Map<String, dynamic>)['notif_requested_spot'] ?? 0,
        buttonVisibility: (doc.data() as Map<String, dynamic>)['notif_button_visibility'] ?? false,
        readyToGo: (doc.data() as Map<String, dynamic>)['notif_ready_to_go'] ?? false,
      );
    }).toList();
  }

  //get post stream
  Stream<List<Post>> get post {
    return postCollection.snapshots().map<List<Post>>(_postListFromSnapshot);
  }

  //get notification stream
  Stream<List<Notifications>> get notifications {
    return notificationCollection.snapshots().map<List<Notifications>>(_notificationListFromSnapshot);
  }
}