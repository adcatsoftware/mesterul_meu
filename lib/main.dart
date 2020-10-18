import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

//Pachetele creat de mine:
import 'package:mesterulmeu/components/lista_orizontala.dart';
import 'package:mesterulmeu/drawer_components/categorii_drawer.dart';
import 'package:mesterulmeu/drawer_components/despre_drawer.dart';
import 'package:mesterulmeu/drawer_components/login_page_drawer.dart';
import 'package:mesterulmeu/drawer_components/profil_drawer.dart';
import 'package:mesterulmeu/mesteri/mesteri_list.dart';

void main() {
  set();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

void set() {}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 100.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/plumbing-840835.jpg'),
          AssetImage('images/tools-864983.jpg'),
        ], //Imagini prezentare bara sus
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(seconds: 1),
        dotColor: Colors.green,
        dotSize: 3.0,
        indicatorBgPadding: 1.0,
      ),
    );
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
              icon: Icon(Icons.search), color: Colors.black, onPressed: () {}),
//        Implementare Messenger!!!
//          new IconButton(
//              icon: Icon(Icons.message),
//              color: Colors.black,
//              onPressed: () {
//                Navigator.push(context,
//                    MaterialPageRoute(builder: (context) => new Mesagerie()));
//              }),
        ],
      ),
      drawer: new Drawer(
        child: ListView(
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
                      return GestureDetector(
                        child: ListTile(
                          title: Text(
                              'Cunoști un meșter? Recomandă-l pe platforma meșterul meu!'),
                          leading: Icon(Icons.add, color: Colors.red),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new HomePage()));
                        },
                      );
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
                if (FirebaseAuth.instance.currentUser() == null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }
              },
              child: ListTile(
                title: Text('Contul meu'),
                leading: Icon(
                  Icons.account_circle,
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              title: Text('Pagina Principală'),
              leading: Icon(
                Icons.home,
                color: Colors.amber,
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
      body: new ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          //Slide-uri imagini comanda
          image_carousel,
          //Textul categorii sub slide-ul cu imagini
          new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Text('Categorii'),
          ),
          ListaOrizontala(),
          //Lista meșteri pagina principala
          new Padding(
            padding: const EdgeInsets.all(12.0),
            child: new Text('Meșteri de peste tot'),
          ),
          //Preparare grid view
          Container(
            height: 500,
            child: MesteriList(),
          )
        ],
      ),
    );
  }
}
