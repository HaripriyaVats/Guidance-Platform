import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
 abstract class BaseAuth{
   Future<String> signInWithEmailAndPassword (String email, String password);
   Future<String> createUserWithEmailAndPassword (String email, String password);
   Future<User> currentUser();
   Future <void> signOut();
   Future deleteUser(String email, String password);
 }
class Auth implements BaseAuth{
  Future<String> signInWithEmailAndPassword (String email, String password) async {
    UserCredential userCred = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: email,
        password: password);
    User user = userCred.user;
    return user.uid;
  }
  Future<String> createUserWithEmailAndPassword (String email, String password) async {
    UserCredential userCred = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: email,
        password: password);
    User user = userCred.user;
    return user.uid;
  }

  Future<User> currentUser() async {
    var user = await FirebaseAuth.instance.currentUser;
    return user;
  }
 Future <void> signOut() async{
    return FirebaseAuth.instance.signOut();
 }
  Future deleteUser(String email, String password) async {

    try {
      User user = await currentUser();
      user.delete();
      print('User Deleted');

    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  }