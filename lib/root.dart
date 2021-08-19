import 'package:codehelp/auth/auth.dart';
import 'package:codehelp/homepage.dart';
import 'package:flutter/material.dart';
import './auth/login.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus{
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.notSignedIn;

  initState() {
    super.initState();
    // widget.auth.currentUser().then(userId){
    //   setState((){
    //     authStatus=userId == null? AuthStatus.notSignedIn : AuthStatus.SignedIn;
    //   });

   widget.auth.currentUser().then((userId){
      setState(() {
        _authStatus = (userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn);
      });
    });
  }
 void signedIn(){
   setState(() {
     _authStatus  = AuthStatus.signedIn;
   });
 }
 void _signedOut(){
    setState(() {
      _authStatus  = AuthStatus.notSignedIn;
    });
 }
  @override
  Widget build(BuildContext context) {
    switch(_authStatus)
    {
      case AuthStatus.notSignedIn:
        return LoginPage(
            auth: widget.auth,
            onSignedIn: signedIn,
        );
      case AuthStatus.signedIn:
         return HomePage(
           auth: widget.auth,
           onSignedOut: _signedOut,
         );
      // default:return LoginPage(
      //   auth: widget.auth,
      //   onSignedIn: _signedIn,
      // );
    }

  }
}
