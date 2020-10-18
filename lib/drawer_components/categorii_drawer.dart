import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mesterulmeu/categorii/amenajari_interioare.dart';
import 'package:mesterulmeu/categorii/auto.dart';
import 'package:mesterulmeu/categorii/bucatarie.dart';
import 'package:mesterulmeu/drawer_components/profil_drawer.dart';

import 'package:mesterulmeu/main.dart';
import 'package:mesterulmeu/drawer_components/login_page_drawer.dart';

class CategoriiDrawer extends StatefulWidget {
  @override
  _CategoriiDrawerState createState() => _CategoriiDrawerState();
}

class _CategoriiDrawerState extends State<CategoriiDrawer> {
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
              onTap: () {},
              child: ListTile(
                title: Text('Despre'),
                leading: Icon(Icons.live_help, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
      body: CategoriiPaginaPrincipala(),
    );
  }
}

class CategoriiPaginaPrincipala extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                title: Text(
                  "Auto",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.75,
                ),
                leading: Image.asset(
                  'images/categorii/cars.png',
                  fit: BoxFit.fitHeight,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new AutoAppBar()));
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Amenajări interioare",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.75,
                ),
                leading: Image.asset(
                  'images/categorii/construction.png',
                  fit: BoxFit.fitHeight,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new AmenajariInterioare()));
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Bucătărie",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.75,
                ),
                leading: Image.asset(
                  'images/categorii/furniture-and-household.png',
                  fit: BoxFit.fitHeight,
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new Bucatarie()));
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Curățenie",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.75,
                ),
                leading: Image.asset(
                  'images/categorii/Curatenie.png',
                  fit: BoxFit.fitHeight,
                ),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Construcții",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.75,
                ),
                leading: Image.asset(
                  'images/categorii/truck.png',
                  fit: BoxFit.fitHeight,
                ),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Electrocasnice",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.75,
                ),
                leading: Image.asset(
                  'images/categorii/electronics.png',
                  fit: BoxFit.fitHeight,
                ),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Grădinărit",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.75,
                ),
                leading: Image.asset(
                  'images/categorii/spade.png',
                  fit: BoxFit.fitHeight,
                ),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Instalații electrice",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.75,
                ),
                leading: Image.asset(
                  'images/categorii/man.png',
                  fit: BoxFit.fitHeight,
                ),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Instalații sanitare",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.75,
                ),
                leading: Image.asset(
                  'images/categorii/plumber.png',
                  fit: BoxFit.fitHeight,
                ),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Instalații termice",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.75,
                ),
                leading: Image.asset(
                  'images/categorii/technology.png',
                  fit: BoxFit.fitHeight,
                ),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Mobilă",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.75,
                ),
                leading: Image.asset(
                  'images/categorii/wardrobe.png',
                  fit: BoxFit.fitHeight,
                ),
                onTap: () {},
              ),
            ],
          ).toList(),
        ));
  }
}
