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

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  get _firebaseAuth => null;

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
          actions: <Widget>[
            new IconButton(
                icon: Icon(Icons.search), color: Colors.black, onPressed: () {})
          ]),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            Container(
              child: FutureBuilder<FirebaseUser>(
                  future: FirebaseAuth.instance.currentUser(),
                  builder: (BuildContext context,
                      AsyncSnapshot<FirebaseUser> snapshot) {
                    if (snapshot.hasData) {
                      return StreamBuilder(
                          stream: Firestore.instance
                              .collection('mesteri')
                              .where('email',
                                  isEqualTo: snapshot.data.email.toString())
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return UserAccountsDrawerHeader(
                                      accountName: Text(snapshot
                                              .data.documents[index]['nume'] +
                                          " " +
                                          snapshot.data.documents[index]
                                              ['prenume']),
                                      accountEmail: Text("Email: " +
                                          snapshot.data.documents[index]
                                              ['email']),
                                      currentAccountPicture: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      new ProfilePage()));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.green,
                                          child: Image.network(snapshot
                                              .data.documents[index]['imageURL']
                                              .toString()),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.green), //Culoare Drawer
                                    );
                                  });
                            } else {
                              return CircularProgressIndicator();
                            }
                          });
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new CategoriiDrawer()));
              },
              child: ListTile(
                title: Text('Categorii'),
                leading: Icon(
                  Icons.dashboard,
                  color: Colors.black,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Contul meu'),
                leading: Icon(
                  Icons.account_circle,
                  color: Colors.blue,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: ListTile(
                title: Text('Pagina Principală'),
                leading: Icon(
                  Icons.home,
                  color: Colors.amber,
                ),
              ),
            ),
//            InkWell(
//              onTap: () {},
//              child: ListTile(
//                title: Text('Favoriți'),
//                leading: Icon(Icons.favorite_border, color: Colors.red),
//              ),
//            ),
            Divider(),
//            InkWell(
//              onTap: () {},
//              child: ListTile(
//                title: Text('Setări'),
//                leading: Icon(
//                  Icons.settings,
//                  color: Colors.blueGrey,
//                ),
//              ),
//            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new DesprePagina()));
              },
              child: ListTile(
                title: Text('Despre'),
                leading: Icon(Icons.live_help, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
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
