import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Thing {
  String id;
  String name;
  String description;
  bool reward;
  String rewardDescription;
  String userID;
  List<String> images = [];
  Timestamp dateAdded;
  Timestamp expiration;

  Thing(
      {this.name,
      this.description,
      this.reward,
      this.rewardDescription,
      this.userID,
      this.images,
      this.dateAdded,
      this.expiration,
      this.id});

  factory Thing.fromFireStore(DocumentSnapshot _doc) {
    var thingData = _doc.data;
    return Thing(
      name: thingData["name"],
      description: thingData["description"],
      reward: thingData["reward"],
      rewardDescription: thingData["reward_description"],
      userID: thingData["user_id"],
      images: List<String>.from(thingData["images"]),
      dateAdded: thingData["date_added"],
      expiration: thingData["expiration"],
      id: _doc.documentID,
    );
  }
}
