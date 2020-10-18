import 'package:flutter/material.dart';
import 'package:mesterulmeu/main.dart';

class BaraSusMester extends StatefulWidget {
  @override
  _BaraSusMesterState createState() => _BaraSusMesterState();
}

class _BaraSusMesterState extends State<BaraSusMester> {
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
    ));
  }
}
