//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:firebase_auth/firebase_auth.dart';
import 'package:collab/models/users.dart';
import 'package:collab/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create user object based on FirebaseUser
  Users _userFromFirebaseUser(User? user) {
    if(user != null) {
      return Users(user.uid);
    } else {
      return Users('');
    }
  }

  //auth change user stream
  Stream<Users> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }


  //sign in anonymous
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;

      await DatabaseService(uid: user.uid).updateUserData('', DateTime.now(), DateTime.now(), '');
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString);
      return null;
    }
  }
}