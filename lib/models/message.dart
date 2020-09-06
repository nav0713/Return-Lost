import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String message;
  final String senderID;
  final String type;
  final Timestamp timestamp;

  Message({this.message, this.senderID, this.type, this.timestamp});


  factory Message.fromFirestore(DocumentSnapshot _document){
    var data = _document.data;
    return Message(
      message: data["message"],
      senderID: data["senderID"],
      timestamp: data["timestamp"],
      type: data["type"],
    );
  }
}