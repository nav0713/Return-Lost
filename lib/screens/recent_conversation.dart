import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:returnlost/components/zero_content.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import '../components/delete_conversation.dart';
import '../components/drawer.dart';
import '../components/user_chat_list.dart';
import '../services/database_service.dart';
import '../services/login_services.dart';
import '../models/contact.dart';
import '../models/user.dart';
import '../models/message.dart';
import '../screens/conversation_page.dart';
import '../styles.dart';

class RecentConversation extends StatefulWidget {
  @override
  _RecentConversationState createState() => _RecentConversationState();
}

class _RecentConversationState extends State<RecentConversation> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: LoginState.instance,
    child: Scaffold(
      drawer: NavigationDrawer(parentContext: context),
        appBar: AppBar(
          title: Text("Messages"),
          centerTitle: true,

    ),
      body: Consumer<LoginState>(
        builder: (context, user, child){
          return StreamBuilder<List<Contact>>(
            stream: DBService.instance.getContact(user.userData.id),
            builder: (context, snapshot){
             if(snapshot.hasData){
               var _contact = snapshot.data;
               return ListView.builder(
                   itemCount: _contact.length,
                   itemBuilder: (context, index){
                     return FutureBuilder<User>(
                       future: DBService.instance.getUser(_contact[index].id),
                       builder:(context, data){
                         if(data.hasData){
                           var userData = data.data;
                           return FutureBuilder<Message>(
                             future: DBService.instance.getLastMessage(_contact[index].conversationID, user.userData.id),
                             builder: (context, data){
                               if(data.hasData && (data.connectionState == ConnectionState.active || data.connectionState == ConnectionState.waiting)){
                                 return Shimmer.fromColors(
                                   child: Container(
                                     padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),

                                     child:Row(
                                       children: <Widget>[CircleAvatar(radius: 35,),
                                         SizedBox(width: 20,),
                                         Container(
                                           width: MediaQuery.of(context).size.width *.65,
                                           height: 60.0,
                                           color: Colors.grey,
                                         )
                                       ],
                                     )
                                     ,                                  ),
                                   baseColor: Colors.grey.withOpacity(.5),
                                   highlightColor: Colors.white,
                                 );
                               }else if(data.hasData && data.connectionState == ConnectionState.done){
                                 var lastMessageInfo = data.data;
                                 return Dismissible(
                                   key: ValueKey(index),
                                   direction: DismissDirection.startToEnd,
                                   onDismissed: (direction){

                                   },
                                   confirmDismiss: (direction)async{
                                     final result = await showDialog(context: context, builder: (context){
                                       return deleteDialog(context);
                                     });
                                     if(result){
                                       await DBService.instance.deleteConversation(_contact[index].conversationID, user.userData.id);
                                     }
                                     return result;
                                   },
                                   background: Container(
                                     color: Colors.redAccent,
                                     padding: EdgeInsets.only(left: 16.0),
                                     child: Align(
                                       alignment: Alignment.center,
                                       child: Row(children: <Widget>[
                                         Text("Delete Conversation?",style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),),
                                         SizedBox(width: 12,),
                                         Icon(Icons.delete, color: Colors.white,)
                                       ],),
                                     ),
                                   ),
                                   child: GestureDetector(child: UserChatList(name: userData.name, image: userData.image,message: lastMessageInfo.message,timestamp: lastMessageInfo.timestamp,senderID: lastMessageInfo.senderID,currentUserID: user.userData.id,),
                                     onTap: (){
                                       User otherUser = User(
                                           name: userData.name,
                                           id:userData.id,
                                           image: userData.image
                                       );
                                       Navigator.push(context, MaterialPageRoute(
                                           builder: (BuildContext context){
                                             return ConversationPage(conversationID:_contact[index].conversationID, otherUser:otherUser,currentUser: user.userData,);
                                           }
                                       )).then((value){
                                         setState(() {
                                         });
                                       });
                                     },
                                   ),
                                 );
                               }else if(!data.hasData && data.data == null && data.connectionState == ConnectionState.done){
                                 return Container(
                                     padding: EdgeInsets.only(top: 200.0),
                                     child: NoContent("You do not have message at the moment"));
                               }else{
                                 return Container();
                               }
                             },
                           );
                         }else{
                           return Container(
                           );
                         }
                       },
                     );
                   });
             }else{
              return Center(
                child: SpinKitFadingCircle(
                  size: 70.0,
                  color: redColor,
                ),
              );
             }
            },
          );
        },
      ),
    ),
    );
  }
}
