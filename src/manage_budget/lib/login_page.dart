import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_page.dart';

  final formKey = new GlobalKey<FormState>();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
  }

  class LoginPage extends StatefulWidget {
    @override
      State<StatefulWidget> createState() => new _LoginPageState();
  }

  class _LoginPageState extends State<LoginPage>{
    @override
      Widget build(BuildContext context) {
      return Scaffold(
        //appBar: AppBar(
        //  title: Text('Login Page'),
        //),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 80.0),
              Column(
                children: <Widget>[
                  Image.asset('assets/icon2.png'),
                  SizedBox(height: 17.0),
                  Text('Manage Budget'),
                ],
              ),
              SizedBox(height: 120.0),
              Center(
                child: RaisedButton(
                  child: Text('Login/SignUp'),
                  onPressed: () {
                    _handleSignIn();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                    );
                  },
                ),
              )

            ],
            
          )
          
        ),
      );

       //onPressed: _handleSignIn,

    }
  }
