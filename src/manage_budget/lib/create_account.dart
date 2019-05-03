import 'package:flutter/material.dart';

  final formKey_createAccount = new GlobalKey<FormState>();

  String _firstName;
  String _lastName;
  String _email;
  String _password;


  class createAccount extends StatefulWidget {
    @override
      State<StatefulWidget> createState() => new _createAccountState();

  }

  class _createAccountState extends State<createAccount>{
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Create an Account'),
          centerTitle: true,
          elevation: 1.0,
        ),
        body: Column(
          children: <Widget>[
            Form(
              key: formKey_createAccount,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
                      child: new TextFormField(
                        decoration: new InputDecoration(labelText: 'First Name'),
                        validator: (value) => value.isEmpty ? 'First Name can\'t be empty' : null,
                        onSaved: (value) => _firstName = value,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
                      child: new TextFormField(
                        obscureText: true,
                        decoration: new InputDecoration(labelText: 'Last Name'),
                        validator: (value) => value.isEmpty ? 'Last Name can\'t be empty' : null,
                        onSaved: (value) => _lastName = value,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
                      child: new TextFormField(
                        obscureText: true,
                        decoration: new InputDecoration(labelText: 'Email'),
                        validator: (value) => value.isEmpty ? 'Last Name can\'t be empty' : null,
                        onSaved: (value) => _email = value,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
                      child: new TextFormField(
                        obscureText: true,
                        decoration: new InputDecoration(labelText: 'Password'),
                        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
                        onSaved: (value) => _password = value,
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.only(right: 25.0, top: 25.0),
                        child: OutlineButton(
                          highlightedBorderColor: Colors.black,
                          onPressed: () {
                            //_registerAccount();
                          },
                          child: const Text('Register'),
                        ),
                      ),
                    ],
                  ),
                ],
              ) ,
            )
          ],
        ),
      );
    }
  }