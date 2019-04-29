import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_page.dart';


  String _email;
  String _password;

  bool _connect_google = false;
  bool _connect = false;

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
    if(user.uid != null){
      _connect_google = true;
    }else{
      _connect_google = false;
    }
    return user;
  }

  bool _validate(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }

    return false;
  }

  void _login() async{
    if(_validate()){
      try{
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        print('Signed in: ${user.uid}');
        if(user.uid != null){
          _connect = true;
        }else{
          _connect = false;
        }
      }catch(e){
        //not doing anything currently
        print('Error: $e');
      }
    }
  }

  void _createAccount() {

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
                  SizedBox(height: 100.0,
                      child: Image.asset('assets/icon.jpg')
                  ),
                  SizedBox(height: 17.0),
                  Text(
                    "Manage Budget",
                    style: new TextStyle(fontFamily: 'Rubik-Regular',
                        fontSize: 30.0),
                  ),
                ],
              ),
              SizedBox(height: 90.0),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: new TextFormField(
                        decoration: new InputDecoration(labelText: 'Email'),
                        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
                        onSaved: (value) => _email = value,
                      ),
                    ),
                    new SizedBox(
                      height: 6.0,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: new TextFormField(
                        obscureText: true,
                        decoration: new InputDecoration(labelText: 'Password'),
                        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
                        onSaved: (value) => _password = value,
                      ),
                    ),
                  ],
                ) ,
              ),
              SizedBox(
                height: 25.0,
              ),
              Center(
                child: RaisedButton(
                  padding: EdgeInsets.all(8.0),
                  textColor: Colors.white,
                  color: Color(0xFF18D191),
                  child: new Text("Login"),
                  onPressed: () {
                    _login();
                    if(_connect == true){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                      );
                    }
                  }
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Center(
                child: RaisedButton.icon(
                  color: Color(0xFFFFFDFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  elevation: 8.0,
                  highlightElevation: 6.0,
                  icon: Image.asset('assets/google_icon.png', height: 24.0),
                  label: Text('Sign in with Google'),
                  onPressed: () {
                    _handleSignIn();
                    if(_connect_google == true){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                      );
                    }
                  },
                ),
              ),
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 100, horizontal: 0),
                child: Text(
                  "Create an Account"
                ),
                onPressed: () {
                  _createAccount();
                },
              )
            ],
          )
        ),
      );
    }
  }
