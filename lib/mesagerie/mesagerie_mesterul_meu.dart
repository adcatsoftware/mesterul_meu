import 'package:flutter/material.dart';
import 'package:mesterulmeu/global.dart';
import 'package:mesterulmeu/mesagerie/chat.dart';

class Mesagerie extends StatefulWidget {
  @override
  _MesagerieState createState() => _MesagerieState();
}

class _MesagerieState extends State<Mesagerie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.green),
        elevation: 0.1,
        backgroundColor: Colors.white, //Culoare bara de sus AppBar
        title: Image.asset('images/logo_size.jpg', fit: BoxFit.cover),
        centerTitle: true,

        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.search), color: Colors.black, onPressed: () {}),
        ],
      ),
    );
  }
}

class MesagerieChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatPage(),
    );
  }
}
