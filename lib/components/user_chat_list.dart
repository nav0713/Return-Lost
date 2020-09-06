import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

///user chat list user interface
class UserChatList extends StatelessWidget {
  final String image;
  final String name;
  final String message;
  final Timestamp timestamp;
  String currentUserID;
  String senderID;
  UserChatList({this.image,this.name,this.message,this.timestamp,this.currentUserID,this.senderID});
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 100,
      child: Card(
        elevation: 5.0,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.5),
                          spreadRadius: -8,
                          blurRadius: 5
                      ),
                    ]
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: CachedNetworkImageProvider(image),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width *.70,
                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[Text(
                          name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                        ),
                          Text(timeago.format(timestamp.toDate()).toString())
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      child: senderID == currentUserID?Text("you: $message",overflow: TextOverflow.ellipsis) : Text( message,overflow: TextOverflow.ellipsis),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
