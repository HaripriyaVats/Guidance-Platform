import 'package:codehelp/auth/auth.dart';
import 'package:codehelp/root.dart';
import 'package:flutter/material.dart';
import './register.dart';
import 'auth.dart';
enum FormType {
  login,
  Register,
}
class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;  //voidcallback is a function that takes no parameters and returns parameters
  State<StatefulWidget> createState()=> new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  @override
  String email;
  String password;
  FormType formType = FormType.login;
  final formKey = new GlobalKey<FormState>();
  bool save(){
    final form= formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }

  void submit() async {
    if(save()==true)  {
   try {
     String userId= await widget.auth.signInWithEmailAndPassword(email, password);
     widget.onSignedIn();
     print('Signed in : ' + userId);

   }
   catch(e){
     print('Error');
   }
    }
  }
  void moveToRegister(){
    formKey.currentState.reset();
    setState((){
      formType=FormType.Register;
    });
  }
  void moveToLogin(){
    formKey.currentState.reset();
    setState((){
      formType= FormType.login;
    });
  }
  void register() async {
    if (save() == true) {
      try {
        String userId= await widget.auth.createUserWithEmailAndPassword(email, password);
        print('Signed up :' + userId);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  Register(auth: widget.auth, userId: userId, email: email, password: password, callHomePage: callHomePage, onSignedIn: widget.onSignedIn,)),

        );
        // Navigator.pushAndRemoveUntil<dynamic>(
        //   context,
        //   MaterialPageRoute<dynamic>(
        //     builder: (BuildContext context) => Register( auth: widget.auth,
        //                                                  userId: userId,
        //                                                  email: email,
        //                                                  password: password,
        //                                                  callHomePage: callHomePage,
        //                                                  onSignedIn: widget.onSignedIn,)
        //                                                 ),
        //       (route) => false,//if you want to disable back feature set to false
        // );
      }
      catch (e) {
        print('Error');
      }
    }
  }
  void callHomePage(){
    widget.onSignedIn();
   // MaterialPageRoute(builder: (context) =>  HomePage(auth: this.widget.auth,));
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('CodeHelp'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: new Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
             buildInputs()+ buildSubmits(),
          ),
        ),
      ),
    );
  }
    List<Widget>  buildInputs(){
      return [  TextFormField(
        decoration: InputDecoration(
          labelText: 'Email',
        ),
        validator: (value) => value.isEmpty? 'Email can\'t be empty': null,
        onSaved: (value) => email=value,
      ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Password',
          ),
          obscureText: true,
          validator: (value) {
            // return value.isEmpty? 'Password can\'t be empty': null;
             if(value.isEmpty){
               return 'Password can\'t be empty';
             }
             else  if(value.length<6){
               return 'Password should be of atleast 6 characters';
             }
             else return null;
          },

          onSaved: (value) {
              password=value;
          }
        ),
      ];
    }
  List<Widget>  buildSubmits() {
    if(formType==FormType.login) {
      return [
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: submit,
          child: Text('Login', style: TextStyle(fontSize: 20)),
        ),
        SizedBox(height: 5),
        ElevatedButton(
            onPressed: moveToRegister,
            child: Text('Create an account', style: TextStyle(fontSize: 20))),
      ];
    }
    else {
      return [
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: register,
          child: Text('Next', style: TextStyle(fontSize: 20)),
        ),
        SizedBox(height: 5),
        ElevatedButton(
            onPressed: moveToLogin,
            child: Text('Have an account? Login', style: TextStyle(fontSize: 20))),
      ];
    }
  }

  }


