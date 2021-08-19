import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './root.dart';
import './auth/auth.dart';
Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();  //to ensure everything is initialised
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fapp= Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:FutureBuilder(
        future: _fapp,
        builder: (context,snapshot){
          if(snapshot.hasError){
            print("Error- ${snapshot.error.toString()}");
            return Text('Something went wrong');
          }
          else if(snapshot.hasData){
            return RootPage(auth: new Auth());
          }
          else{
           return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
      //MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
    ),
    );
  }
}
