import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:mesterulmeu/Login_SignUp/authentificate.dart';
import 'package:mesterulmeu/Login_SignUp/constants.dart';
import 'package:mesterulmeu/Login_SignUp/database.dart';
import 'package:mesterulmeu/main.dart';

import 'categorii_drawer.dart';
import 'despre_drawer.dart';
import 'login_page_drawer.dart';
import 'package:mesterulmeu/pagini/login_page_without_app_bar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _firebaseAuth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _formKeyCategorie = GlobalKey<FormState>();
  final _formKeyTelefon = GlobalKey<FormState>();
  bool loading = false;
  String newNume;
  String newPrenume;
  String newJudet;
  String newProgram;
  String newDescriere;
  String newCategorie;
  String newImageURL;
  String newTelefon;
  final List<String> categorie = <String>[];
  final List<String> categoriiToate = <String>[
    'Auto',
    'Amenajări interioare',
    'Bucătărie',
    'Curățenie',
    'Construcții',
    'Electrocasnice',
    'Grădinărit',
    'Instalații electrice',
    'Instalații sanitare',
    'Instalații termice',
    'Mobilă'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.green),
          elevation: 0.1,
          backgroundColor: Colors.white,
          //Culoare bara de sus AppBar
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
                icon: Icon(Icons.search),
                color: Colors.black,
                onPressed: () {}),
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
                onTap: () async {
                  return FutureBuilder<FirebaseUser>(
                      future: FirebaseAuth.instance.currentUser(),
                      builder: (BuildContext context,
                          AsyncSnapshot<FirebaseUser> snapshot) {
                        if (!snapshot.hasData) {
                          FirebaseUser user =
                              snapshot.data; // this is your user instance
                          /// is because there is user already logged
                          return ProfilePage();
                        }

                        /// other way there is no user logged.
                        return HomePage();
                      });
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
            child: FutureBuilder<FirebaseUser>(
                future: FirebaseAuth.instance.currentUser(),
                builder: (BuildContext context,
                    AsyncSnapshot<FirebaseUser> snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data.email.toString());
                    return StreamBuilder(
                        stream: Firestore.instance
                            .collection('mesteri')
                            .where('email',
                                isEqualTo: snapshot.data.email.toString())
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                                child: ListView.builder(
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Container(
                                              height: 250,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(snapshot
                                                      .data
                                                      .documents[index]
                                                          ['imageURL']
                                                      .toString()),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Text(
                                              "Numele dvs:",
                                              textScaleFactor: 1.75,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                snapshot.data
                                                    .documents[index]['nume']
                                                    .toString(),
                                                softWrap: true,
                                                textScaleFactor: 2.0),
                                            Container(
                                              width: 1.0,
                                              height: 40,
                                              child: RaisedButton(
                                                color: Colors.green,
                                                focusColor: Colors.green,
                                                child: Text(
                                                    'Schimbați-vă numele '),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuilderContext) {
                                                        return AlertDialog(
                                                          scrollable: false,
                                                          content: Form(
                                                              key: _formKey,
                                                              child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    SizedBox(
                                                                      height: 5,
                                                                      width: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      showCursor:
                                                                          true,
                                                                      focusNode:
                                                                          FocusNode(
                                                                              canRequestFocus: false),
                                                                      decoration:
                                                                          textInputDecoration.copyWith(
                                                                              hintText: 'Introduceți un nume nou'),
                                                                      validator: (val) => val
                                                                              .isEmpty
                                                                          ? 'Introduceți numele dvs. nou!'
                                                                          : null,
                                                                      onChanged:
                                                                          (val) {
                                                                        setState(() =>
                                                                            newNume =
                                                                                val);
                                                                      },
                                                                    ),
                                                                    RaisedButton(
                                                                        child: Text(
                                                                            "Accept"),
                                                                        onPressed:
                                                                            () async {
                                                                          if (_formKey
                                                                              .currentState
                                                                              .validate()) {
                                                                            Firestore.instance.collection('mesteri').document(snapshot.data.documents[index]['email'].toString()).updateData({
                                                                              'nume': newNume.toString()
                                                                            });
                                                                            Navigator.push(context,
                                                                                MaterialPageRoute(builder: (context) => new ProfilePage()));
                                                                          } else {
                                                                            AlertDialog(
                                                                              content: Text("Nu ați introdus nimic!"),
                                                                            );
                                                                          }
                                                                        }),
                                                                  ])),
                                                        );
                                                      });
                                                },
                                              ),
                                            ),
                                            Divider(
                                              height: 10,
                                            ),
                                            Text(
                                              "Prenumele dvs:",
                                              textScaleFactor: 1.75,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              snapshot.data
                                                  .documents[index]['prenume']
                                                  .toString(),
                                              textScaleFactor: 2.0,
                                            ),
                                            Container(
                                              width: 1.0,
                                              height: 40,
                                              child: RaisedButton(
                                                color: Colors.green,
                                                focusColor: Colors.green,
                                                child: Text(
                                                    'Schimbați-vă prenumele '),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuilderContext) {
                                                        return AlertDialog(
                                                          scrollable: false,
                                                          content: Form(
                                                              key: _formKey,
                                                              child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    SizedBox(
                                                                      height: 5,
                                                                      width: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      showCursor:
                                                                          true,
                                                                      focusNode:
                                                                          FocusNode(
                                                                              canRequestFocus: false),
                                                                      decoration:
                                                                          textInputDecoration.copyWith(
                                                                              hintText: 'Introduceți un prenume nou'),
                                                                      validator: (val) => val
                                                                              .isEmpty
                                                                          ? 'Introduceți prenumele dvs. nou!'
                                                                          : null,
                                                                      onChanged:
                                                                          (val) {
                                                                        setState(() =>
                                                                            newPrenume =
                                                                                val);
                                                                      },
                                                                    ),
                                                                    Container(
                                                                      child: RaisedButton(
                                                                          child: Text("Accept"),
                                                                          onPressed: () async {
                                                                            if (_formKey.currentState.validate()) {
                                                                              Firestore.instance.collection('mesteri').document(snapshot.data.documents[index]['email'].toString()).updateData({
                                                                                'prenume': newPrenume.toString()
                                                                              });
                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => new ProfilePage()));
                                                                            } else {
                                                                              AlertDialog(
                                                                                content: Text("Nu ați introdus nimic!"),
                                                                              );
                                                                            }
                                                                          }),
                                                                    ),
                                                                  ])),
                                                        );
                                                      });
                                                },
                                              ),
                                            ),
                                            Divider(
                                              height: 15,
                                            ),
                                            Text(
                                              "Categoriile dvs.:",
                                              textScaleFactor: 1.75,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              snapshot.data
                                                  .documents[index]['categorie']
                                                  .toString()
                                                  .replaceFirst('[', '')
                                                  .replaceFirst(']', ''),
                                              textScaleFactor: 2,
                                              softWrap: true,
                                            ),
                                            DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              value: categorie.isEmpty
                                                  ? null
                                                  : categorie.last,
                                              hint: Text("Categorie Meșter: "),
                                              onChanged: (newCategorie) {
                                                setState(() {
                                                  if (categorie
                                                      .contains(newCategorie))
                                                    categorie
                                                        .remove(newCategorie);
                                                  else
                                                    categorie.add(newCategorie);
                                                });

                                                print(categorie);
                                              },
                                              validator: (value) => value ==
                                                      null
                                                  ? 'Selectați cel puțin o categorie ! Câmp obligatoriu!'
                                                  : null,
                                              items: categoriiToate.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.check,
                                                        color: categorie
                                                                .contains(value)
                                                            ? null
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                      SizedBox(width: 30),
                                                      Text(
                                                        '$value',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        softWrap: true,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            Text(
                                              'Categorii Selectate: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textScaleFactor: 1.35,
                                            ),
                                            Divider(
                                              height: 5,
                                            ),
                                            Wrap(
                                              direction: Axis.horizontal,
                                              alignment: WrapAlignment.start,
                                              children: categorie
                                                  .map((categorie) => Text(
                                                        categorie + "; ",
                                                        softWrap: false,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        textScaleFactor: 1.3,
                                                      ))
                                                  .toList(),
                                            ),
                                            Divider(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 40,
                                              child: Form(
                                                key: _formKeyCategorie,
                                                child: RaisedButton(
                                                    color: Colors.green,
                                                    focusColor: Colors.green,
                                                    child: Text(
                                                        "Acceptați schimbarea categoriei/categoriilor de meșter"),
                                                    onPressed: () async {
                                                      print(categorie);
                                                      if (_formKeyCategorie
                                                          .currentState
                                                          .validate()) {
                                                        Firestore.instance
                                                            .collection(
                                                                'mesteri')
                                                            .document(snapshot
                                                                .data
                                                                .documents[
                                                                    index]
                                                                    ['email']
                                                                .toString())
                                                            .updateData({
                                                          'categorie': categorie
                                                        });
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        new ProfilePage()));
                                                      } else {
                                                        AlertDialog(
                                                          content: Text(
                                                              "Nu ați introdus nimic!"),
                                                        );
                                                      }
                                                    }),
                                              ),
                                            ),
                                            Divider(
                                              height: 15,
                                            ),
                                            Text(
                                              'Numărul de telefon: ',
                                              textScaleFactor: 1.75,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                snapshot.data
                                                    .documents[index]['telefon']
                                                    .toString(),
                                                softWrap: true,
                                                textScaleFactor: 2.0),
                                            Container(
                                              width: 1.0,
                                              height: 40,
                                              child: RaisedButton(
                                                color: Colors.green,
                                                focusColor: Colors.green,
                                                child: Text(
                                                    'Schimbați-vă numărul de telefon '),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuilderContext) {
                                                        return AlertDialog(
                                                          scrollable: false,
                                                          content: Form(
                                                              key: _formKey,
                                                              child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    SizedBox(
                                                                      height: 5,
                                                                      width: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      showCursor:
                                                                          true,
                                                                      focusNode:
                                                                          FocusNode(
                                                                              canRequestFocus: false),
                                                                      decoration:
                                                                          textInputDecoration.copyWith(
                                                                              hintText: 'Introduceți un număr de telefon nou'),
                                                                      validator: (val) => val
                                                                              .isEmpty
                                                                          ? 'Introduceți numărul dvs. de telefon nou!'
                                                                          : null,
                                                                      onChanged:
                                                                          (val) {
                                                                        setState(() =>
                                                                            newTelefon =
                                                                                val);
                                                                      },
                                                                    ),
                                                                    RaisedButton(
                                                                        child: Text(
                                                                            "Accept"),
                                                                        onPressed:
                                                                            () async {
                                                                          if (_formKey
                                                                              .currentState
                                                                              .validate()) {
                                                                            Firestore.instance.collection('mesteri').document(snapshot.data.documents[index]['email'].toString()).updateData({
                                                                              'telefon': newTelefon.toString()
                                                                            });
                                                                            Navigator.push(context,
                                                                                MaterialPageRoute(builder: (context) => new ProfilePage()));
                                                                          } else {
                                                                            AlertDialog(
                                                                              content: Text("Nu ați introdus nimic!"),
                                                                            );
                                                                          }
                                                                        }),
                                                                  ])),
                                                        );
                                                      });
                                                },
                                              ),
                                            ),
                                            Divider(
                                              height: 15,
                                            ),
                                            Text("Programul dvs: ",
                                                textScaleFactor: 1.75,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                snapshot.data
                                                    .documents[index]['program']
                                                    .toString(),
                                                softWrap: true,
                                                textScaleFactor: 2.0),
                                            Container(
                                              width: 1.0,
                                              height: 40,
                                              child: RaisedButton(
                                                color: Colors.green,
                                                focusColor: Colors.green,
                                                child: Text(
                                                    'Schimbați-vă programul '),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuilderContext) {
                                                        return AlertDialog(
                                                          scrollable: false,
                                                          content: Form(
                                                              key: _formKey,
                                                              child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    SizedBox(
                                                                      height: 5,
                                                                      width: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      showCursor:
                                                                          true,
                                                                      focusNode:
                                                                          FocusNode(
                                                                              canRequestFocus: false),
                                                                      decoration:
                                                                          textInputDecoration.copyWith(
                                                                              hintText: 'Introduceți un program nou'),
                                                                      validator: (val) => val
                                                                              .isEmpty
                                                                          ? 'Introduceți programul dvs. nou!'
                                                                          : null,
                                                                      onChanged:
                                                                          (val) {
                                                                        setState(() =>
                                                                            newProgram =
                                                                                val);
                                                                      },
                                                                    ),
                                                                    Container(
                                                                      child: RaisedButton(
                                                                          child: Text("Accept"),
                                                                          onPressed: () async {
                                                                            if (_formKey.currentState.validate()) {
                                                                              Firestore.instance.collection('mesteri').document(snapshot.data.documents[index]['email'].toString()).updateData({
                                                                                'program': newProgram.toString()
                                                                              });
                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => new ProfilePage()));
                                                                            } else {
                                                                              AlertDialog(
                                                                                content: Text("Nu ați introdus nimic!"),
                                                                              );
                                                                            }
                                                                          }),
                                                                    ),
                                                                  ])),
                                                        );
                                                      });
                                                },
                                              ),
                                            ),
                                            Divider(
                                              height: 15,
                                            ),
                                            Text("Descrierea dvs. ",
                                                textScaleFactor: 1.75,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                snapshot
                                                    .data
                                                    .documents[index]
                                                        ['descriere']
                                                    .toString(),
                                                softWrap: true,
                                                textScaleFactor: 1.35),
                                            Container(
                                              width: 20,
                                              height: 40,
                                              child: RaisedButton(
                                                color: Colors.green,
                                                focusColor: Colors.green,
                                                child: Text(
                                                    'Schimbați-vă descrierea dvs '),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuilderContext) {
                                                        return AlertDialog(
                                                          scrollable: false,
                                                          content: Form(
                                                              key: _formKey,
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .stretch,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: <
                                                                        Widget>[
                                                                      SizedBox(
                                                                        height:
                                                                            30,
                                                                        width:
                                                                            20,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            300,
                                                                        height:
                                                                            350,
                                                                        child:
                                                                            TextFormField(
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              height: 2.0,
                                                                              color: Colors.black),
                                                                          keyboardType:
                                                                              TextInputType.multiline,
                                                                          maxLines:
                                                                              15,
                                                                          showCursor:
                                                                              true,
                                                                          focusNode:
                                                                              FocusNode(canRequestFocus: false),
                                                                          decoration:
                                                                              textInputDecoration.copyWith(hintText: 'Introduceți un program nou'),
                                                                          validator: (val) => val.isEmpty
                                                                              ? 'Introduceți descrierea dvs. nouă!'
                                                                              : null,
                                                                          onChanged:
                                                                              (val) {
                                                                            setState(() =>
                                                                                newDescriere = val);
                                                                          },
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child: RaisedButton(
                                                                            child: Text("Accept"),
                                                                            onPressed: () async {
                                                                              if (_formKey.currentState.validate()) {
                                                                                Firestore.instance.collection('mesteri').document(snapshot.data.documents[index]['email'].toString()).updateData({
                                                                                  'descriere': newDescriere.toString()
                                                                                });
                                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => new ProfilePage()));
                                                                              } else {
                                                                                AlertDialog(
                                                                                  content: Text("Nu ați introdus nimic!"),
                                                                                );
                                                                              }
                                                                            }),
                                                                      ),
                                                                    ]),
                                                              )),
                                                        );
                                                      });
                                                },
                                              ),
                                            ),
                                            Divider(
                                              height: 15,
                                            ),
                                            Text("Adresa imagine :",
                                                textScaleFactor: 1.75,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                snapshot
                                                    .data
                                                    .documents[index]
                                                        ['imageURL']
                                                    .toString(),
                                                softWrap: true,
                                                textScaleFactor: 1.1),
                                            Container(
                                              width: 1.0,
                                              height: 40,
                                              child: RaisedButton(
                                                color: Colors.green,
                                                focusColor: Colors.green,
                                                child: Text(
                                                    'Schimbați imaginea dvs. '),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuilderContext) {
                                                        return AlertDialog(
                                                          scrollable: false,
                                                          content: Form(
                                                              key: _formKey,
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .stretch,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    SizedBox(
                                                                      height: 5,
                                                                      width: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .multiline,
                                                                      maxLines:
                                                                          5,
                                                                      showCursor:
                                                                          true,
                                                                      focusNode:
                                                                          FocusNode(
                                                                              canRequestFocus: false),
                                                                      decoration:
                                                                          textInputDecoration.copyWith(
                                                                              hintText: 'Introduceți un adresă/link către o nouă imagine'),
                                                                      validator: (val) => val
                                                                              .isEmpty
                                                                          ? 'Introduceți un adresă/link către o nouă imagine'
                                                                          : null,
                                                                      onChanged:
                                                                          (val) {
                                                                        setState(() =>
                                                                            newImageURL =
                                                                                val);
                                                                      },
                                                                    ),
                                                                    Container(
                                                                      child: RaisedButton(
                                                                          child: Text("Accept"),
                                                                          onPressed: () async {
                                                                            if (_formKey.currentState.validate()) {
                                                                              Firestore.instance.collection('mesteri').document(snapshot.data.documents[index]['email'].toString()).updateData({
                                                                                'imageURL': newImageURL.toString()
                                                                              });
                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => new ProfilePage()));
                                                                            } else {
                                                                              AlertDialog(
                                                                                content: Text("Nu ați introdus nimic!"),
                                                                              );
                                                                            }
                                                                          }),
                                                                    ),
                                                                  ])),
                                                        );
                                                      });
                                                },
                                              ),
                                            ),
                                            Divider(
                                              height: 100,
                                            ),
                                          ],
                                        ),
                                      );
                                    }));
                          } else {
                            return CircularProgressIndicator();
                          }
                        });
                  } else {
                    return LoginPageWithoutAppBar();
                  }
                })));
  }
}
