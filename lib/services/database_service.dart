import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:returnlost/models/contact.dart';
import 'package:returnlost/models/qr.dart';
import 'package:returnlost/services/navigation_service.dart';
import 'package:uuid_enhanced/uuid.dart';
import '../models/user.dart';
import '../models/things.dart';
import '../components/alerts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import '../components/loading_dialog.dart';
import '../models/qr.dart';
import '../models/message.dart';
class DBService {
  User user;
  QRCode qr;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final userRef = Firestore.instance.collection('User');
  final conversationRef = Firestore.instance.collection("conversation");
  final qrRef = Firestore.instance.collection("qr-codes");
  final thingsRef = Firestore.instance.collection("Things");
  static DBService instance = DBService();
  final _auth = FirebaseAuth.instance;

  Future<User> getUserData(String uid) async {
    DocumentSnapshot _doc = await userRef.document(uid).get();
    user = User.fromFirestore(_doc);
    return user;
  }


  /// Get Single Item
  Future<Thing> getItem(String itemID)async{
    try{
      DocumentSnapshot _doc = await thingsRef.document(itemID).get();
      if(_doc.exists){
        Thing item = Thing.fromFireStore(_doc);
        return item;
      }else{
        return null;
      }
    }catch(e){
      print(e.toString());
    }
  }
/// get QR code details
  Future<QRCode> getQRCode(String code, BuildContext context) async {
    try {
      DocumentSnapshot _doc = await qrRef.document(code).get();
      qr = QRCode.fromFireStore(_doc);
      return qr;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkQRUsage(String code, BuildContext context) async {
    try {
      DocumentSnapshot _doc = await thingsRef.document(code).get();
      if (_doc.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      showAlert("Error", "Something went wrong. Please try Again", context,
          AlertType.error, () {
        Navigator.of(context, rootNavigator: true).pop();
      });
    }
  }

  ///register new user
  Future<void> register(String email, String password, User user, context) async{
    try{
      AuthResult _result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if(_result != null){
        FirebaseUser newUser = _result.user;
        userRef.document(newUser.uid).setData({
          "name" : user.name,
          "username":user.username,
          "image" : user.image
        }).then((value) {
          showAlert("Register Successful", "You can now Login your account", context,
              AlertType.success, () {
                Navigator.of(context, rootNavigator: true).pop();
                NavigationService.instance.navigateToReplacement("login");
              });
        }).catchError((error){
          showAlert("Error", "Something went wrong. Please try Again", context,
              AlertType.error, () {
                Navigator.of(context, rootNavigator: true).pop();
              });
        });
      }
    }catch(e){
      print(e.toString());
    }
  }

  ///add item
  Future<void> addItem(Thing newThing, context, QRCode qr) async {
    try {
      thingsRef.document(qr.id).setData({
        "name": newThing.name,
        "description": newThing.description,
        "reward": newThing.reward,
        "reward_description": newThing.rewardDescription,
        "user_id": newThing.userID,
        "images": newThing.images,
        "date_added": newThing.dateAdded,
        "expiration": newThing.expiration,
      }).then((value) {
        showAlert("Adding Successful", "New item successfully added", context,
            AlertType.success, () {
          Navigator.of(context, rootNavigator: true).pop();
          NavigationService.instance.navigateToReplacement("home");
        });
      });
    } catch (e) {
      showAlert("Error", "Something went wrong. Please try Again", context,
          AlertType.error, () {
        Navigator.of(context, rootNavigator: true).pop();
      });
    }
  }

  ///update item
  Future<void> updateItem(Thing newThing, context) async {
  Dialogs.showLoadingDialog(
      context, _keyLoader, "Updating Item");
    try {
      thingsRef.document(newThing.id).updateData({
        "name": newThing.name,
        "description": newThing.description,
        "reward": newThing.reward,
        "reward_description": newThing.rewardDescription,
        "user_id": newThing.userID,
        "images": newThing.images,
        "date_added": newThing.dateAdded,
        "expiration": newThing.expiration,
      }).then((value) {
        print("value");
        showAlert("Update Successful", "New item successfully Updated", context,
            AlertType.success, () {
          Navigator.of(context, rootNavigator: true).pop();
        NavigationService.instance.navigateToReplacement("home").then((value) =>    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop());
        });
      }).catchError((error) {
        print("error");
        showAlert("Error", "Something went wrong. Please try Again", context,
            AlertType.error, () {
              Navigator.of(context, rootNavigator: true).pop();
            });
      });
    } catch (e) {
      showAlert("Error", "Something went wrong. Please try Again", context,
          AlertType.error, () {
        Navigator.of(context, rootNavigator: true).pop();
      });
    }
  }

  Future<void> updateUserAvatar(String uid, String url) {
    try {
      userRef.document(uid).updateData({
        "image": url,
      });
      return null;
    } catch (e) {
      print(e);
    }
  }
///update username
  Future<void> updateUserName(String uid, String name) {
    try {
      userRef.document(uid).updateData({
        "name": name,
      });
      return null;
    } catch (e) {
      print(e);
    }
  }
///delete item
  Future<void> deleteItem(context, String id) {
    DocumentReference _doc = Firestore.instance.document("Things/$id");
    try {
      _doc.delete().then((value) {
        showAlert(
            "Deleted", "Item is deleted Successfully", context, AlertType.info,
            () {
          Navigator.of(context, rootNavigator: true).pop();
          NavigationService.instance.navigateToReplacement("home");
        });
      }).catchError(() {
        showAlert("Error", "Something went wrong. Please try Again", context,
            AlertType.error, () {
          Navigator.of(context, rootNavigator: true).pop();
        });
      });
    } catch (e) {
      showAlert("Error", "Something went wrong. Please try Again", context,
          AlertType.error, () {
        Navigator.of(context, rootNavigator: true).pop();
      });
    }
  }


  ///GET ALL CONTACTS OF THE USER
  Stream<List<Contact>> getContact(String currentUserID){
    try{
      final _contacts = userRef.document(currentUserID).collection("contact").getDocuments().asStream();
      return _contacts.map((_doc){
        return _doc.documents.map((data){
          return Contact.fromFirestore(data);
        }).toList();
      });
    }catch(e){
      print(e.toString());
    }
  }

 ///GET SINGLE USER
  Future<User> getUser(String userID)async{
    DocumentSnapshot _document = await userRef.document(userID).get();
    User user = User.fromFirestore(_document);
    return user;
  }

  ///get the information of the last message the user has chat with
  Future<Message> getLastMessage(String convoID, String currentUserID)async{
    print(convoID);
    print(currentUserID);
    try{
      final _doc = await conversationRef.document(convoID).collection(currentUserID).document("chats").get();
     if(_doc != null){
       final _messages = _doc.data["messages"];
       final _messageLength = _messages.length;
       final _lastMessage = _messages[_messageLength-1];
       Message _lastMessageInfo = Message(
           message: _lastMessage["message"],
           timestamp: _lastMessage["timestamp"],
           type: _lastMessage["type"],
           senderID: _lastMessage["senderID"]
       );
       return _lastMessageInfo;
     }else{
       print("not exist");
     }
    }catch(e){
      print(e.toString());
    }
  }

  ///SEND MESSAGE METHOD
  Future<void> sendMessage(String convoID, userID, Message _message){
    try{
      final _ref = conversationRef.document(convoID).collection(userID).document("chats");
      _ref.updateData({
        "messages": FieldValue.arrayUnion([
          {
            "message" : _message.message,
            "senderID" : _message.senderID,
            "timestamp": _message.timestamp,
            "type":_message.type
          }
        ])
      });
    }catch(e){
      print(e.toString());
    }
  }
///Delete Conversation
  Future<void> deleteConversation(String convoId, String currentUserID)async{
    try{
      final _doc = await conversationRef.document(convoId).collection(currentUserID).document("chats").get();
      if(_doc.exists){
        await  conversationRef.document(convoId).collection(currentUserID).document("chats").setData({
          "messages":[],
        });
      }
    }catch(e){
      print(e.toString());
    }
  }

  /// Create User Contact
  Future<void>createContact(String recipientID, String currentUserID,)async{
    try{
      final getContact1 = await userRef.document(currentUserID).collection("contact").document(recipientID).get();
      final getContact2 = await userRef.document(recipientID).collection("contact").document(currentUserID).get();
      if(getContact1.exists && getContact2.exists){
        print("contact already existed");
        return null;
      }else{
        String uid = Uuid.fromTime().toString();
        final currentUserContact = await userRef.document(currentUserID).collection("contact").document(recipientID).setData({
          "conversationID" : uid,
          "id": recipientID,

        });

        final recipientContact = await userRef.document(recipientID).collection("contact").document(currentUserID).setData({
          "conversationID" : uid,
          "id": currentUserID

        });
      }

    }catch(e){
      print(e.toString());
    }
  }

  ///get Single Contact
  Future<Contact> getSingleContact(String userID, String recipientID)async{
    try{
      DocumentSnapshot _doc = await userRef.document(userID).collection("contact").document(recipientID).get();
      Contact contact = Contact.fromFirestore(_doc);
      return contact;
    }catch(e){
      print(e.toString());
    }

  }
  ///Create User Conversation
  Future<void> createConversation(String convoID , String recipiendID, String userID) async{
    try{

      final currentUserConvo = await conversationRef.document(convoID).collection(userID).document("chats").get();
      final recipientConvo = await conversationRef.document(convoID).collection(userID).document("chats").get();

      if(currentUserConvo.exists || recipientConvo.exists){
        return;
      }else{
        await conversationRef.document(convoID).collection(userID).document("chats").setData({
          "messages":[],
        });
        await conversationRef.document(convoID).collection(recipiendID).document("chats").setData({
          "messages":[],
        });
      }

    }catch(e){
      print(e.toString());
    }
  }
  ///get user things register
  Future<int> getThingsCount(String currentUserID) async{
    try{
      QuerySnapshot _documents =  await thingsRef.where("user_id", isEqualTo: currentUserID).getDocuments();
      return _documents.documents.length;
    }catch(e){
      print(e.toString());
    }
  }

}
