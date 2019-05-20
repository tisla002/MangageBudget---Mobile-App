import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manage_budget/create_account.dart';
import 'package:manage_budget/firebase.dart';
import 'main_page.dart';
import 'firebase.dart';
import 'package:manage_budget/creditsAndExpenses.dart';
import 'package:manage_budget/budget_page.dart';


  String _email;
  String _password;

  String _userID;
  String userID;

  bool connect = false;

  final formKey = new GlobalKey<FormState>();

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _error;

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    _userID = user.uid;
    userID = user.uid;
    newuser(_userID);
    return user;
  }

  String returnUserID(){
    return _userID;
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
          _userID = user.uid;
          userID = user.uid;
          connect = true;
        }else{
          _userID = "";
          userID = "";
          connect = false;
        }

      }catch(e){
        //not doing anything currently
        _error = e.toString();
        print('Error: $e');
      }
    }
  }

  void error(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("Login Error"),
      content: Text(_error, style: TextStyle(fontSize: 10.0),),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );
  }

  void _onLoading(BuildContext context) {
    var alertDialog = AlertDialog(
      content: Container(
        height: 60.0,
        child: Column(
          children: <Widget>[
            CircularProgressIndicator(),
            Text('Loading')
          ],
        ),
      )
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return alertDialog;
      }
    );
    new Future.delayed(new Duration(seconds: 1), () {
      _email = null;
      _password = null;
      formKey.currentState.reset();
      Navigator.pop(context); //pop dialog
      Navigator.push(context, new MaterialPageRoute(builder: (context) => new MainPage()),);
    });
  }

  class LoginPage extends StatefulWidget {
    @override
      State<StatefulWidget> createState() => new _LoginPageState();
  }

  class _LoginPageState extends State<LoginPage>{

  @override
  void initState() {
    super.initState();
    connect = false;
    _email = null;
    _password = null;
  }

    @override
      Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Column(
            //padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 65.0),
                  child: icon(),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 25.0),
                child: textfields(),
              ),
              Container(
                padding: EdgeInsets.only(top: 30.0),
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
                controller: email,
                decoration: new InputDecoration(labelText: 'Email'),
                validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
                onSaved: (value) => _email = email.text,
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
              child: new TextFormField(
                controller: password,
                obscureText: true,
                decoration: new InputDecoration(labelText: 'Password'),
                validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
                onSaved: (value) => _password = password.text,
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
                    if(connect != false ){
                      returnUserID();
                      grabHistory(returnUserID());
                      budgetHistory(returnUserID());
                      grabHistory2(userID, "");
                      budgetHistory2(returnUserID(),"");
                      budgetLimit(userID, "");
                      budgetLimit2(returnUserID());

                      _onLoading(context);

                    }else{
                      error(context);
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