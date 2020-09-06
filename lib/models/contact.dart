import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
class Contact{
  final String id;
  final String conversationID;
  Contact({this.id, this.conversationID});

  factory Contact.fromFirestore(DocumentSnapshot _document){
    var data = _document.data;
    return Contact(
      conversationID: _document["conversationID"],
      id: _document["id"],
    );
  }

}