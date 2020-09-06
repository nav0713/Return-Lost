import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User {
  String name;
  String image;
  String username;
  String id;

  User({this.name, this.image, this.username, this.id});

  factory User.fromFirestore(DocumentSnapshot _doc) {
    var _userData = _doc.data;
    return User(
      name: _userData["name"],
      image: _userData["image"],
      username: _userData["username"],
      id: _doc.documentID,
    );
  }
}
