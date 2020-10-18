import 'package:flutter/material.dart';
import 'package:mesterulmeu/categorii/amenajari_interioare.dart';
import 'package:mesterulmeu/categorii/auto.dart';
import 'package:mesterulmeu/categorii/bucatarie.dart';

class ListaOrizontala extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.0,
      width: 30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new AutoAppBar()));
            },
            child: Categorii(
              image_location: 'images/categorii/cars.png',
              image_caption: 'Auto',
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new AmenajariInterioare()));
            },
            child: Categorii(
              image_location: 'images/categorii/construction.png',
              image_caption: 'Amenajări interioare',
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new Bucatarie()));
              },
              child: Categorii(
                image_location: 'images/categorii/furniture-and-household.png',
                image_caption: 'Bucătărie',
              )),
          GestureDetector(
            onTap: () {},
            child: Categorii(
              image_location: 'images/categorii/Curatenie.png',
              image_caption: 'Curățenie',
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Categorii(
              image_location: 'images/categorii/truck.png',
              image_caption: 'Construcții',
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Categorii(
              image_location: 'images/categorii/electronics.png',
              image_caption: 'Electrocasnice',
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Categorii(
              image_location: 'images/categorii/spade.png',
              image_caption: 'Grădinărit',
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Categorii(
              image_location: 'images/categorii/man.png',
              image_caption: 'Instalații electrice',
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Categorii(
              image_location: 'images/categorii/plumber.png',
              image_caption: 'Instalații sanitare',
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Categorii(
              image_location: 'images/categorii/technology.png',
              image_caption: 'Instalații termice',
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Categorii(
              image_location: 'images/categorii/wardrobe.png',
              image_caption: 'Mobilă',
            ),
          ),
        ],
      ),
    );
  }
}

class Categorii extends StatelessWidget {
  final String image_location;
  final String image_caption;
  Categorii({
    this.image_location,
    this.image_caption,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        width: 110.0,
        height: 100.0,
        child: ListTile(
          title: Image.asset(image_location),
          subtitle: Container(
            alignment: Alignment.topCenter,
            child: Text(
              image_caption,
              textAlign: TextAlign.center,
              style: new TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
