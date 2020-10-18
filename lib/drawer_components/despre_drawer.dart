import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:mesterulmeu/drawer_components/profil_drawer.dart';

import 'package:mesterulmeu/main.dart';
import 'package:mesterulmeu/drawer_components/categorii_drawer.dart';
import 'package:mesterulmeu/drawer_components/login_page_drawer.dart';

class DespreDrawer extends StatefulWidget {
  @override
  _DespreDrawerState createState() => _DespreDrawerState();
}

class _DespreDrawerState extends State<DespreDrawer> {
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
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
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
      body: DesprePagina(),
    );
  }
}

class DesprePagina extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
