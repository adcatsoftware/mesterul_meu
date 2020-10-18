import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:mesterulmeu/drawer_components/categorii_drawer.dart';
import 'package:mesterulmeu/drawer_components/despre_drawer.dart';
import 'package:mesterulmeu/drawer_components/login_page_drawer.dart';
import 'package:mesterulmeu/drawer_components/profil_drawer.dart';
import 'package:mesterulmeu/main.dart';
import 'package:mesterulmeu/pagini/mester_detalii.dart';

class AutoAppBar extends StatefulWidget {
  @override
  _AutoAppBarState createState() => _AutoAppBarState();
}

class _AutoAppBarState extends State<AutoAppBar> {
  String judet;

  _AutoAppBarState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.green),
          elevation: 0.1,
          backgroundColor: Colors.white, //Culoare bara de sus AppBar
          title: Center(
            child: new DropdownButtonFormField<String>(
              icon: Icon(Icons.map),
              value: judet,
              hint: Text("Meșter AUTO. Alege județul: "),
              onChanged: (judet) {
                setState(() {});
                this.judet = judet;
                print(judet);
              },
              validator: (value) =>
                  value == null ? 'Selectați județul! Câmp obligatoriu!' : null,
              items: <String>[
                'Alba',
                'Arad',
                'Argeș',
                'Bacău',
                'Bihor',
                'Bistrița-Năsăud',
                'Botoșani',
                'Brașov',
                'Brăila',
                'București',
                'Buzău',
                'Caraș-Severin',
                'Călărași',
                'Cluj',
                'Constanța',
                'Covasna',
                'Dâmbovița',
                'Dolj',
                'Galați',
                'Giurgiu',
                'Gorj',
                'Harghita',
                'Hunedoara',
                'Ialomița',
                'Iași',
                'Ilfov',
                'Maramureș',
                'Mehedinți',
                'Mureș',
                'Neamț',
                'Olt',
                'Prahova',
                'Satu Mare',
                'Sălaj',
                'Sibiu',
                'Suceava',
                'Teleorman',
                'Timiș',
                'Tulcea',
                'Vaslui',
                'Vâlcea',
                'Vrancea',
              ].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
            ),
          ),

          centerTitle: true,

          actions: <Widget>[],
        ),
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
                                            child: Image.network(snapshot.data
                                                .documents[index]['imageURL']
                                                .toString()),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.green), //Culoare Drawer
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
                          builder: (context) => new DespreDrawer()));
                },
                child: ListTile(
                  title: Text('Despre'),
                  leading: Icon(Icons.live_help, color: Colors.green),
                ),
              ),
            ],
          ),
        ),
        body: Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(5.0),
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection("mesteri")
                    .where('categorie', arrayContains: "Auto")
                    .where('judet', isEqualTo: judet)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return Text('Loading ...');
                  final orientation = MediaQuery.of(context).orientation;
                  print(snapshot.data.documents.length);

                  return GridView.builder(
                    itemCount: snapshot.data.documents.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border:
                                Border.all(width: 3.25, color: Colors.green),
                            borderRadius: BorderRadius.circular(20)),
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          child: new GridTile(
                            header: new Image.network(
                              snapshot.data.documents[index]['imageURL']
                                  .toString(),
                              height: 100,
                              width: 100,
                            ),
                            footer: new Text(
                              snapshot.data.documents[index]['nume']
                                      .toString() +
                                  " " +
                                  snapshot.data.documents[index]['prenume']
                                      .toString(),
                              textScaleFactor: 1.2,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            child: Text('\n' +
                                '\n' +
                                '\n' +
                                '\n' +
                                '\n' +
                                '\n' +
                                '\n' +
                                "Judet: " +
                                snapshot.data.documents[index]['judet']
                                    .toString()),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new MesterDetalii(
                                        emailMesterCurent1: snapshot
                                            .data.documents[index]['email']
                                            .toString())));
                          },
                        ),
                      );
                    },
                  );
                  print(snapshot.data.documents);
                })));
  }
}
