import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';

class MesterDetalii extends StatefulWidget {
  final String emailMesterCurent1;
  MesterDetalii({Key key, @required this.emailMesterCurent1}) : super(key: key);
  @override
  _MesterDetaliiState createState() => _MesterDetaliiState();
}

class _MesterDetaliiState extends State<MesterDetalii> {
  _MesterDetaliiState();

  @override
  Widget build(BuildContext context) {
    print(widget.emailMesterCurent1);
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
//        Implementare search/cautare in baza de date!!!!!
          new IconButton(
              icon: Icon(Icons.search), color: Colors.black, onPressed: () {}),
//        Implementare mesagerie!!!
//          new IconButton(
//              icon: Icon(Icons.message), color: Colors.black, onPressed: () {}),
        ],
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('mesteri')
              .where('email', isEqualTo: widget.emailMesterCurent1.toString())
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          children: <Widget>[
                            new Container(
                              height: 300.0,
                              child: GridTile(
                                  child: Container(
                                    color: Colors.white,
                                    child: Image.network(
                                      snapshot.data.documents[index]['imageURL']
                                          .toString(),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  footer: new Container(
                                    height: 60.0,
                                    color: Colors.green,
                                    child: ListTile(
                                      leading: new Text(
                                          snapshot.data.documents[index]['nume']
                                                  .toString() +
                                              " " +
                                              snapshot.data
                                                  .documents[index]['prenume']
                                                  .toString(),
                                          textScaleFactor: 1.5),
                                      subtitle: new Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: new Text(
                                              "Categorie: " +
                                                  snapshot
                                                      .data
                                                      .documents[index]
                                                          ['categorie']
                                                      .toString()
                                                      .replaceFirst('[', '')
                                                      .replaceFirst(']', ''),
                                              textScaleFactor: 1.15,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: () async {
                                      String telephoneURL = "tel:" +
                                          snapshot
                                              .data.documents[index]['telefon']
                                              .toString()
                                              .toString();
                                      print(telephoneURL.toString());
                                      if (await canLaunch(telephoneURL)) {
                                        await launch(telephoneURL);
                                      } else {
                                        throw "Can't phone that number.";
                                      }
                                    },
                                    color: Colors.white,
                                    textColor: Colors.black,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: new Text(
                                            "Sună Meșterul:   " +
                                                snapshot.data
                                                    .documents[index]['telefon']
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: () async {
                                      canLaunch('sms');
                                    },
                                    color: Colors.white,
                                    textColor: Colors.black,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: new Text(
                                            "Trimite SMS:  " +
                                                snapshot.data
                                                    .documents[index]['telefon']
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: RaisedButton(
                                    onPressed: () async {
                                      launch("mailto:" +
                                          snapshot
                                              .data.documents[index]['email']
                                              .toString());
                                    },
                                    color: Colors.white,
                                    textColor: Colors.black,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: new Text(
                                            "Trimite-i un email:  " +
                                                snapshot.data
                                                    .documents[index]['email']
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                new ListTile(
                                  title: new Text("Detalii"),
                                  subtitle: new Text(snapshot
                                      .data.documents[index]['descriere']
                                      .toString()),
                                ),
                              ],
                            ),
                            Divider(),
                          ]),
                    );
                  });
            } else
              return Text('Eroare');
          }),
    );
  }
}
