import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class crudMethod {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(mester) async {
    if (isLoggedIn()) {
      Firestore.instance.collection('mesteri').add(mester).catchError((e) {
        Text('Already in use');
      });
    }
  }
}
