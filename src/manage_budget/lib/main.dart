import 'package:flutter/material.dart';
import 'package:manage_budget/login_page.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:manage_budget/notifications.dart';



void main(){
  notifyInit();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
    Widget build(BuildContext context){

    return new MaterialApp(
      title: 'Manage Budget',
      theme: new ThemeData(
        //brightness: Brightness.light,
        //primaryColor: Colors.white,
        //accentColor: Colors.white,
        //buttonColor: Color(0xFFFFFDFF),
        //primarySwatch: Colors.lightBlueAccent[200],
        //primarySwatch: Colors.greenAccent[400],
        primarySwatch: Colors.green
      ),
      home: new LoginPage()

    );
  }
}
