import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mesterulmeu/main.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({Key key, this.auth});
  final BaseAuth auth;

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  String _email = '';
  TextEditingController _emailController;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
// Clean up the controller when the widget is disposed.
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            iconTheme: IconThemeData(color: Colors.green),
            elevation: 0.1,
            backgroundColor: Colors.white, //Culoare bara de sus AppBar
            title: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new HomePage()));
                },
                child: Image.asset(
                  'images/logo_size.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            centerTitle: true,
            actions: <Widget>[]),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              Text(
                'Vă rog să verificați și folderul de Spam/Junk pentru linkul de resetare a parolei!',
                style: TextStyle(fontWeight: FontWeight.bold),
                textScaleFactor: 1.5,
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                child: new TextField(
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  decoration: new InputDecoration(
                      hintText: 'Email dvs.',
                      icon: new Icon(
                        Icons.mail,
                        color: Colors.grey,
                      )),
                  onChanged: (value) {
                    _email = value;
                  },
                  controller: _emailController,
                ),
              ),
              new Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                  child: RaisedButton(
                    child: new Text('Resetează parola',
                        style: new TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      try {
                        await widget.auth.resetPassword(_email);
                      } catch (e) {
                        print(e);
                      }
                    },
                  ))
            ],
          ),
        ));
  }
}

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut();
  Future<void> resetPassword(String email);
}

class Authe implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<String> signIn(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)) as FirebaseUser;
    if (user.isEmailVerified) {
      return user.uid;
    } else {
      // ignore: deprecated_member_use
      Fluttertoast.showToast(
          msg:
              'Verificați-vă emailul pentru și accesați linkul pentru a valida contul');
    }
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password)) as FirebaseUser;
    await user.sendEmailVerification();
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
