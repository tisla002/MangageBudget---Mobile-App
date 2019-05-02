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
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
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
      ),
    );
  }
}


//using this for sign out currently, we can totally remove this
/*onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pop(context);
          },*/

//child: Text('Log Out'),