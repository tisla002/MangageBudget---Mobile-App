import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manage_budget/create_account.dart';
import 'main_page.dart';


  String _email;
  String _password;

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

  _login() async{
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

  class LoginPage extends StatefulWidget {
    @override
      State<StatefulWidget> createState() => new _LoginPageState();
  }

  class _LoginPageState extends State<LoginPage>{
    @override
      Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Column(
            //padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 45.0),
                child: icon(),
              ),
              Container(
                padding: EdgeInsets.only(top: 45.0),
                child: textfields(),
              ),
              Container(
                padding: EdgeInsets.only(top: 20.0),
                child: loginbuttons(),
              )
            ],
          )
        ),
      );
    }
  }

  class icon extends StatelessWidget{
    @override
      Widget build(BuildContext context) {

      /*return Hero(
        tag: ,
        child: Image.asset('assets/icon.jpg'),
      );*/
      return Column(
        children: <Widget>[
          Container(
            height: 100.0,
            child: Image.asset('assets/icon.jpg'),
            padding: EdgeInsets.only(bottom: 17.0),
          ),
          Text(
            "Manage Budget",
            style: new TextStyle(fontFamily: 'Rubik-Regular',
                fontSize: 30.0),
          ),
        ],
      );
    }
  }

  class textfields extends StatelessWidget{
    @override
    Widget build(BuildContext context) {
      return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
              child: new TextFormField(
                decoration: new InputDecoration(labelText: 'Email'),
                validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
                onSaved: (value) => _email = value,
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
              child: new TextFormField(
                obscureText: true,
                decoration: new InputDecoration(labelText: 'Password'),
                validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
                onSaved: (value) => _password = value,
              ),
            ),
          ],
        ) ,
      );
    }
  }

  class loginbuttons extends StatelessWidget{
    @override
    Widget build(BuildContext context) {
      return Column(
        children: <Widget>[
          Container(
            child: RaisedButton(
                padding: EdgeInsets.all(8.0),
                textColor: Colors.white,
                color: Color(0xFF18D191),
                child: new Text("Login"),
                onPressed: () {
                  _login().then((value) {
                    if(_connect != false ){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                      );
                    }
                  });
                }
            ),
          ),
          Container(
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
                _handleSignIn().then((FirebaseUser user) {
                  if(user.uid != null ){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                    );
                  }
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top:100),
            child: FlatButton(
              child: Text(
                  "Create an Account"
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => createAccount()),
                );
              },
            ),
          )
        ],
      );
    }

  }