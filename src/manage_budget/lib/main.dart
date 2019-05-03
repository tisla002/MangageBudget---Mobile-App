import 'package:flutter/material.dart';
import 'package:manage_budget/login_page.dart';



void main(){
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
      ),
      home: new LoginPage()

    );
  }
}
