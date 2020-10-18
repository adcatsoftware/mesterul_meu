import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference mesterCollection =
      Firestore.instance.collection('mesteri');

  Future<void> updateUserData(
      String nume,
      String prenume,
      String categorie,
      String judet,
      String localitate,
      String telefon,
      String email,
      String program,
      String descriere,
      String imageURL) async {
    return await mesterCollection.document(uid).setData({
      'nume': nume,
      'prenume': prenume,
      'categorie': categorie,
      'judet': judet,
      'localitate': localitate,
      'telefon': telefon,
      'email': email,
      'program': program,
      'descriere': descriere,
      'imageURL': imageURL,
    });
  }
}
