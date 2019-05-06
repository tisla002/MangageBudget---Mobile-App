import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:manage_budget/login_page.dart";

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SettingsPageState();

}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context){

    return Scaffold(

      body: Column(
        children: <Widget>[
          Center(
            child: RaisedButton(
              child: Text("Logout"),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value){Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  LoginPage()),
                );});
              },
            ),
          ),
        ],
      ),
    );
  }
}