import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mesterulmeu/Login_SignUp/ResetPassword.dart';

//Pachetele creat de mine:

import 'package:mesterulmeu/drawer_components/categorii_drawer.dart';
import 'package:mesterulmeu/drawer_components/despre_drawer.dart';
import 'package:mesterulmeu/drawer_components/profil_drawer.dart';
import 'package:mesterulmeu/main.dart';
import 'package:mesterulmeu/Login_SignUp/signUp.dart';
import 'package:mesterulmeu/Login_SignUp/authentificate.dart';

class LoginPageWithoutAppBar extends StatefulWidget {
  LoginPageWithoutAppBar({Key key}) : super(key: key);
  @override
  _LoginPageWithoutAppBarState createState() => _LoginPageWithoutAppBarState();
}

class _LoginPageWithoutAppBarState extends State<LoginPageWithoutAppBar> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  get _firebaseAuth => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Divider(height: 60),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Introduceți adresa de email';
                  }
                },
                onSaved: (input) {
                  _email = input;
                },
                decoration: InputDecoration(
                    labelText: 'Email :', fillColor: Colors.green),
                cursorColor: Colors.green,
                textAlign: TextAlign.center,
              ),
              TextFormField(
                validator: (input) {
                  if (input.length < 6) {
                    return 'Parola trebuie sa aibe cel puțin 6 caractere!';
                  }
                },
                onSaved: (input) {
                  _password = input;
                },
                decoration: InputDecoration(
                  labelText: 'Parolă',
                ),
                cursorColor: Colors.green,
                textAlign: TextAlign.center,
                obscureText: true,
              ),
              RaisedButton(
                onPressed: () {
                  Logare();
                },
                child: Text('Logare'),
              ),
              RaisedButton(
                onPressed: () async {
                  AlertDialog(
                    title: Text('Te-ai delogat cu succes!'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () async {
                            await AuthService().signOut();
                          },
                          child: Text('OK'))
                    ],
                  );
                  await AuthService().signOut();
                },
                child: Text('Ieșire din cont'),
              ),
              RaisedButton(
                  onPressed: () {
                    var auth = Authe();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResetPasswordPage(
                                  auth: auth,
                                )));
                  },
                  child: Text('Am uitat parola!')),
              Divider(
                height: 60,
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => signUpPage()));
                },
                child: const Text(
                  'Înregistare Meșter',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                textColor: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> Logare() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user =
            (await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        ))
                .user;

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        return Text('Nu exista!');
        print(e.messege);
      }
    }
  }

  Future<bool> isUserLoggedIn() async {
    var user = await _firebaseAuth.currentUser();
    return user != null;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
