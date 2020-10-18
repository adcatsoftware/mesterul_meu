import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mesterulmeu/pagini/mester_detalii.dart';

class MesteriList extends StatefulWidget {
  @override
  _MesteriListState createState() => _MesteriListState();
}

class _MesteriListState extends State<MesteriList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(5.0),
        child: StreamBuilder(
            stream: Firestore.instance.collection("mesteri").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return Text('Loading ...');
              final orientation = MediaQuery.of(context).orientation;
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
                        border: Border.all(width: 3.25, color: Colors.green),
                        borderRadius: BorderRadius.circular(20)),
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      child: new GridTile(
                        footer: new Image.network(
                          snapshot.data.documents[index]['imageURL'].toString(),
                          height: 100,
                          width: 100,
                        ),
                        header: new Text(
                          snapshot.data.documents[index]['nume'].toString() +
                              " " +
                              snapshot.data.documents[index]['prenume']
                                  .toString() +
                              '\n' +
                              '\n',
                          textScaleFactor: 1.1,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        child: Text(
                          '\n' +
                              "Județ: " +
                              snapshot.data.documents[index]['judet']
                                  .toString() +
                              '\n' +
                              snapshot.data.documents[index]['categorie']
                                  .toString()
                                  .replaceFirst('[', '')
                                  .replaceFirst(']', ''),
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MesterDetalii(
                                      emailMesterCurent1: snapshot
                                          .data.documents[index]['email']
                                          .toString(),
                                    )));
                      },
                    ),
                  );
                },
              );
            }));
  }
}
