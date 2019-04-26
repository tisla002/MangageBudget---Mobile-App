import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//adrian this should be where you are going to be working
class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Page"),
      ),
      body: Center(
        child: RaisedButton(
          //using this for sign out currently, we can totally remove this
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pop(context);
          },
          child: Text('Log Out'),
        ),
      ),
    );
  }
}
