import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:returnlost/components/bg_clipper.dart';
import 'package:returnlost/components/thing_image.dart';
import 'package:returnlost/models/contact.dart';
import 'package:returnlost/models/things.dart';
import 'package:returnlost/models/user.dart';
import 'package:returnlost/services/database_service.dart';
import 'package:returnlost/services/login_services.dart';
import 'package:returnlost/services/navigation_service.dart';
import 'package:returnlost/styles.dart';

import 'conversation_page.dart';


class OwnerDetails extends StatefulWidget {
  Thing item;
  User owner;

  OwnerDetails({this.item,this.owner});

  @override
  _OwnerDetailsState createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {
  double _deviceHeight;
  double _deviceWidth;
  double _paddingTop;
  double _paddingBot;
 bool _loading = false;



  var format = DateFormat.yMMMd("en_US");

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _paddingTop = mediaQuery.padding.bottom;
    _paddingBot = mediaQuery.padding.bottom;
    _deviceHeight = mediaQuery.size.height - (_paddingTop + _paddingBot);
    _deviceWidth = mediaQuery.size.width;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        progressIndicator: SpinKitRing(
          size: 70,
          color: Colors.red,
        ),
        child: SafeArea(
          child: ChangeNotifierProvider.value(
              value: LoginState.instance,
              child: SingleChildScrollView(
                child: Consumer<LoginState>(
                  builder:(context, user, child){
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/user_background.jpg"),
                          fit: BoxFit.cover
                        )
                      ),
                      child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              onPressed: NavigationService.instance.goBack,
                                icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,)
                            ),
                           Container(
                             height: MediaQuery.of(context).size.height * .20,
                             padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                             child: Row(
                               children: <Widget>[
                        Container(
                        width: 100,
                        height: 100.0,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2,color: Colors.white),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image(
                              image: CachedNetworkImageProvider(widget.owner.image),
                              fit: BoxFit.cover,
                          ),
                        ),
                    ),
                                 SizedBox(width: 20.0,),
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: <Widget>[
                                     /// owner information
                                     FittedBox(child: Text(widget.owner.name,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.white),)),
                                    ///send message button
                                     RaisedButton(
                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                       child: Text("Send Message"),
                                       color: redColor,
                                       textColor: Colors.white,
                                       onPressed: ()async{
                                         setState(() {
                                           _loading =true;
                                         });
                                       User recipient = await DBService.instance.getUser(widget.item.userID);
                                       await DBService.instance.createContact(recipient.id, user.userData.id);
                                       Contact contact = await DBService.instance.getSingleContact(user.userData.id, recipient.id);
                                       await DBService.instance.createConversation(contact.conversationID,recipient.id, user.userData.id);
                                       Navigator.push(context, MaterialPageRoute(builder: (context){
                                         return ConversationPage(otherUser: recipient,currentUser: user.userData,conversationID: contact.conversationID,);
                                       }));
                                         setState(() {
                                           _loading =false;
                                         });
                                       },
                                     )

                                   ],
                                 ),
                               ],
                             ),
                           ),
                            /// ITEM DETAILS
                            Container(
                              child: Column(
                                children: <Widget>[

                                  Container(
                                    height: _deviceHeight * .70,
                                    child: Card(
                                      elevation: 4,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: ListView(
                                          children: <Widget>[
                                            ListTile(
                                              dense: true,
                                              title: Text(
                                                widget.item.name,
                                                style: Theme.of(context).primaryTextTheme.display2,
                                              ),
                                              subtitle: Text("Name"),
                                            ),
                                            ListTile(
                                              dense: true,
                                              title: Text(widget.item.description,
                                                  style:
                                                  Theme.of(context).primaryTextTheme.display2),
                                              subtitle: Text("Description"),
                                            ),
                                            Divider(),
                                            ListTile(
                                              dense: true,
                                              title: widget.item.reward
                                                  ? Text(widget.item.rewardDescription,
                                                  style: Theme.of(context)
                                                      .primaryTextTheme
                                                      .display2)
                                                  : Text("No Current Reward",
                                                  style: Theme.of(context)
                                                      .primaryTextTheme
                                                      .display2),
                                              subtitle: Text("Reward Description"),
                                            ),
                                            Divider(),
                                            ListTile(
                                              dense: true,
                                              title: Text(format.format(widget.item.dateAdded.toDate()),
                                                  style:
                                                  Theme.of(context).primaryTextTheme.display2),
                                              subtitle: Text("Date Added"),
                                            ),
                                            Divider(),
                                            ListTile(
                                              dense: true,
                                              title: Text(format.format(widget.item.expiration.toDate()),
                                                  style:
                                                  Theme.of(context).primaryTextTheme.display2),
                                              subtitle: Text("QR code expiration"),
                                            ),
                                            Container(
                                              width: _deviceWidth,
                                              height: _deviceHeight * .50,
                                              child: Card(
                                                child: Carousel(
                                                  autoplay: false,
                                                  dotBgColor: Colors.transparent,
                                                  images: [
                                                    thingImage(widget.item.images[0], widget.item.images),
                                                    thingImage(widget.item.images[1], widget.item.images),
                                                    thingImage(widget.item.images[2], widget.item.images),
                                                  ],
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
                                    ),
                                  ),
                                ],
                              ),
                            )
                      ]
    ),
    );
                  }
                ),
    ),
            )
        ),
      )
    );
  }
}
