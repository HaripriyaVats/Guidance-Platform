import './auth/auth.dart';
import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {
  HomePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  void _signOut() async{
    try{
       await auth.signOut();
       onSignedOut();
    }
    catch(e){
     print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CodeHelp'),
      actions: <Widget>[
        TextButton(
            onPressed: _signOut,
            child: Text('Logout',style: TextStyle(color: Colors.white,)),
        )
      ],
      ),
        body: Container(
          child: Center(

            child: Text('Welcome to CodeHelp ', style: TextStyle(fontSize: 32.0,),),
          ),
        ),
    );
  }
}
