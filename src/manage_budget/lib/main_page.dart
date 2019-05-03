import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:manage_budget/login_page.dart";
import "package:manage_budget/settings.dart";

//adrian this should be where you are going to be working
class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MainPageState();
}



class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    new SizedBox(
      height: 70.0,
      width: double.infinity,
      child: OutlineButton(

          color: Colors.grey[200],
          textColor: Colors.black,
          onPressed: (){

          },
          child: Text("First Submenu")
      ),
    ),


   LoginPage(),



    new SizedBox(
      height: 70.0,
      width: double.infinity,
      child: OutlineButton(
          highlightColor: Colors.green,
          color: Colors.grey,
          textColor: Colors.black,
          onPressed: (){

          },
          child: Text("Third Submenu")
      ),
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Page"),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  SettingsPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text("Overview"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.attach_money),
            title: new Text("Credits/Expenses"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.insert_chart),
            title: new Text("Budgets"),
          ),
        ],
      ),
      body: _children[_currentIndex],
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}



//using this for sign out currently, we can totally remove this
/*onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pop(context);
          },*/

//child: Text('Log Out'),

/*body: Center(
        child: Column(
          children: <Widget>[


            new Image(image: new AssetImage("assets/oof.png")),

            new SizedBox(
              height: 70.0,
              width: double.infinity,
              child: OutlineButton(

                  color: Colors.grey[200],
                  textColor: Colors.black,
                  onPressed: (){

                  },
                  child: Text("First Submenu")
                ),
              ),

            new SizedBox(
              width: double.infinity,
              height: 70.0,
              child: OutlineButton(

                  color: Colors.grey[200],
                  textColor: Colors.black,
                  onPressed: (){

                  },
                  child: Text("Second Submenu")
              ),
            ),
            new SizedBox(
              height: 70.0,
              width: double.infinity,
              child: OutlineButton(
                  highlightColor: Colors.green,
                  color: Colors.grey,
                  textColor: Colors.black,
                  onPressed: (){

                  },
                  child: Text("Second Submenu")
              ),
            ),
          ],
        ),
      ),*/