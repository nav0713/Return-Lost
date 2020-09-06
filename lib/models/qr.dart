import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class QRCode {
  String id;
  Timestamp expiration;

  QRCode({this.id, this.expiration});

  QRCode.fromFireStore(DocumentSnapshot _doc) {
    var qr = _doc.data;
    id = _doc.documentID;
    expiration = qr["expiration"];
  }
}
