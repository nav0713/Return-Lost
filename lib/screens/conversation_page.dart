import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:returnlost/services/database_service.dart';
import 'package:returnlost/styles.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../screens/recent_conversation.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
class ConversationPage extends StatefulWidget {
  final User currentUser;
  final User otherUser;
  final String conversationID;

  ConversationPage({this.otherUser,this.currentUser,this.conversationID});



  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> with TickerProviderStateMixin {

  final conversationRef = Firestore.instance.collection("conversation");
  GlobalKey<FormState> _formKey;
  String _messageText;
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:   Text(widget.otherUser.name),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:conversationRef.document(widget.conversationID).collection(widget.currentUser.id).document("chats").snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          var data = snapshot.data;
          return Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data["messages"].length,
                        itemBuilder: (context, index){
                          var messageInfo = data["messages"][index];
                          return messageInfo["senderID"] == widget.currentUser.id? UserChatMessageBubble(userInfo: widget.currentUser,message: messageInfo,):ChatMessageBubble(otherUser: widget.otherUser,message: messageInfo,);
                        }),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 75,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.photo,size: 25,color: redColor,),
                      ),
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            validator: (input){
                              if(input.length == 0){
                                return "Please enter a message";
                              }else{
                                return null;
                              }
                            },
                            onChanged: (input){
                              _formKey.currentState.save();
                            },
                            onSaved: (input){
                              setState(() {
                                _messageText = input;
                              });
                            },
                            autocorrect: false,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type a message",
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: ()async{
                          if(_formKey.currentState.validate()){
                            Message _newMessage = Message(
                                message: _messageText,
                                type: "text",
                                timestamp: Timestamp.now(),
                                senderID: widget.currentUser.id
                            );
                           await DBService.instance.sendMessage(widget.conversationID, widget.currentUser.id, _newMessage);
                           await DBService.instance.sendMessage(widget.conversationID, widget.otherUser.id, _newMessage);
                            _formKey.currentState.reset();
                          }
                        },
                        icon: Icon(Icons.send,size: 25,color: redColor,),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
class ChatMessageBubble extends StatelessWidget {
 final User otherUser;
  final message;

  ChatMessageBubble({this.otherUser,this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 18,
                backgroundImage: CachedNetworkImageProvider(
                 otherUser.image
                ),
              ),
              SizedBox(
                width: 7.0,
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .80,
                ),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:BorderRadius.only(bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      topRight: Radius.circular(30.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.5),
                          spreadRadius: 2,
                          blurRadius: 5
                      )
                    ]
                ),
                child: Text(message["message"],style: TextStyle(color: Colors.black54,fontSize: 18),),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Container(
            padding: EdgeInsets.only(left: 30.0),
            child:  Text(timeago.format(message["timestamp"].toDate()).toString(),style: TextStyle(fontSize: 12,color: Colors.black38),),
          )
        ],
      ),
    );
  }
}

class UserChatMessageBubble extends StatelessWidget {
  final User userInfo;
  final message;

  UserChatMessageBubble({this.userInfo,this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .80,
                ),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius:BorderRadius.only(bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      topLeft: Radius.circular(30.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.5),
                          spreadRadius: 2,
                          blurRadius: 5
                      )
                    ]
                ),
                child: Text(message["message"],style: TextStyle(color: Colors.black54,fontSize: 18),),
              ),
              SizedBox(width: 7,),
              CircleAvatar(
                radius: 18,
                backgroundImage: CachedNetworkImageProvider(
                    userInfo.image
                ),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Container(
            padding: EdgeInsets.only(right: 30.0),
            child:  Text(timeago.format(message["timestamp"].toDate()).toString(),style: TextStyle(fontSize: 12,color: Colors.black38),),
          )
        ],
      ),
    );
  }
}



