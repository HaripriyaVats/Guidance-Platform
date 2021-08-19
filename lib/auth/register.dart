import 'package:flutter/material.dart';

import './auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import './login.dart';


class Register extends StatefulWidget {
  // Register({this.auth, this.onSignedOut});
  final BaseAuth auth;
  // final VoidCallback onSignedOut;
  Register({this.auth, this.userId,this.email, this.password, this.callHomePage, this.onSignedIn});
 final String email;
 final String password;
  final String userId;
  final VoidCallback callHomePage;
  final VoidCallback onSignedIn;

  @override
  _RegisterState createState() => _RegisterState();
}

class SkillSet {
  final int id;
  final String skill;

  SkillSet({
    this.id,
    this.skill,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'skill': skill,
    };
  }
}

class _RegisterState extends State<Register> {
 // bool check = false;

  bool mentor=false;
  bool mentee= false;
 String name;
 String type;
 String phNumber;
 String org;
 List <SkillSet> skills= [];
 String url;
 static List<SkillSet> skill= [
   SkillSet(id: 0, skill: 'Android Development'),
 SkillSet(id: 1, skill:'Artificial Intelligence'),
 SkillSet(id: 2, skill:'C'),
 SkillSet(id: 3, skill:'C++'),
 SkillSet(id: 4, skill:'CSS'),
 SkillSet(id: 5, skill:'Deep Learning'),
 SkillSet(id: 6, skill:'HTML'),
 SkillSet(id: 7, skill:'JAVA'),
 SkillSet(id: 8, skill:'JavaScipt'),
 SkillSet(id: 9, skill:'Machine Learning'),
 SkillSet(id: 10, skill:'MongoDB'),
 SkillSet(id: 11, skill:'Python'),
 SkillSet(id: 12, skill:'React'),
 SkillSet(id: 13, skill:'Ruby'),
 SkillSet(id: 14, skill:'SQL'),
 SkillSet(id: 15, skill:'Web Development'),
 ];
  final formKey = new GlobalKey<FormState>();
 final _multiSelectKey = GlobalKey<FormFieldState>();
 final _items = skill.map((value) => MultiSelectItem<SkillSet>(value, value.skill)).toList();
 bool save() {
   final form = formKey.currentState;
   if (form.validate()) {
     form.save();
     return true;
   }
   else {
     return false;
   }
 }

 static List<Map> ConvertSkillsToMap(List<SkillSet> skills) {
   List<Map> skillset = [];
  skills.forEach((SkillSet skills) {
     Map step = skills.toMap();
     skillset.add(step);
   });
   return skillset;
 }
  void registerDetails() async {
   if(save()==true) {
     Map<String, bool> map={
       'mentor': mentor,
       'mentee': mentee,
     };
     CollectionReference users = FirebaseFirestore.instance.collection('users');
     users.doc(FirebaseAuth.instance.currentUser.uid).set({
       'Name': name,
       'Email': widget.email,
       'Password': widget.password,
       'Phone Number': phNumber,
       'Organisation': org,
       'Type': map,
       'Skills': ConvertSkillsToMap(skills),
       'url': url,

     })
         .then((value) => print("User Added"))
         .catchError((error) => print("Failed to add user: $error"));
    widget.callHomePage();
     Navigator.pop(context);

   }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title: Text('Details')),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
      child: new Form(
      key: formKey,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Name',
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              hintStyle: TextStyle(color: Colors.black54),
            ),
            validator: (value) => value.isEmpty? 'Name can\'t be empty': null,
            onSaved: (value) => name=value,
          ),
        SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Phone Number',
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                hintStyle: TextStyle(color: Colors.black54),
            ),
            validator: (value){
              if(value.isEmpty) {
                return 'Phone Number can\'t be empty';
              }
              else  if(value.length!=10){
                return 'Phone number should be of 10 digits';
              }
              return null;
            },
            onSaved: (value) => phNumber=value,
          ),
        SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Organisation',
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              hintStyle: TextStyle(color: Colors.black54),
            ),
            validator: (value) => value.isEmpty? 'Organisation can\'t be empty': null,
            onSaved: (value) => org=value,
          ),
        SizedBox(height: 15,),

            Row(
              children: [
                SizedBox(width: 8,),
                Text('Are you a ',style: TextStyle(fontSize: 16.5, color: Colors.black,),),
                SizedBox(width:2,),
                Checkbox(value: mentor,
                    onChanged: (bool value) {
                      setState(() {
                        mentor = value;
                      });
                    },
                ),
                Text('Mentor', style: TextStyle(fontSize: 16, color: Colors.black54,),),
                Checkbox(value: mentee,
                  onChanged: (bool value) {
                    setState(() {
                      mentee = value;
                    });
                  },
                ),
                Text('Mentee',style: TextStyle(fontSize: 16, color: Colors.black54,),),
              ],
            ),
        SizedBox(height: 5),
        MultiSelectBottomSheetField<SkillSet>(
          key: _multiSelectKey,
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          title: Text("Skills"),
          buttonText: Text("Skills", style: TextStyle(fontSize:17, color: Colors.black54), ),
          items: _items,
          searchable: true,
          validator: (values) {
            if (values == null || values.isEmpty) {
              return "Required";
            }
           // List<String> names = values.map((e) => e.name).toList();
            return null;
          },
          onConfirm: (values) {
            setState(() {
              skills = values;
            });
            _multiSelectKey.currentState.validate();
          },
          chipDisplay: MultiSelectChipDisplay(
            onTap: (item) {
              setState(() {
                skills.remove(item);
              });
              _multiSelectKey.currentState.validate();
            },
          ),
        ),
        SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'LinkedIn Profile',
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              hintStyle: TextStyle(color: Colors.black54),
            ),
            validator: (value) => value.isEmpty? 'This Field can\'t be empty': null,
            onSaved: (value) => url=value,
          ),
        SizedBox(height: 20),
          ElevatedButton(
            onPressed: registerDetails,
            child: Text('Register', style: TextStyle(fontSize: 20)),
          ),
        ElevatedButton(
          onPressed: (){
            widget.auth.deleteUser(widget.email,widget.password);
            try {
      Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>( builder: (BuildContext context) => LoginPage( auth: widget.auth,
                                                                            onSignedIn: widget.onSignedIn,),
                                                                      ),
       (route) => false,//if you want to disable back feature set to false
      );
      }
      catch (e) {
          print('Error');
        }
      },
          child: Text('Go to Home Page', style: TextStyle(fontSize: 20)),
        ),
      ],
      ),
      ),
          ),
        ),
      ),
    );
  }
}
