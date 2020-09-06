import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:returnlost/components/zero_content.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../styles.dart';
import '../components/alerts.dart';
import '../components/item_menu.dart';
import '../models/qr.dart';
import '../screens/add_item.dart';
import '../services/database_service.dart';
import '../services/scanner.dart';
import '../screens/login.dart';
import '../services/login_services.dart';
import '../components/drawer.dart';
import '../models/things.dart';
import '../widgets/view_image.dart';

class HomeWithProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>.value(
        value: LoginState.instance, child: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final thingsRef = Firestore.instance.collection("Things");
  double _deviceHeight;
  double _deviceWidth;
  double _paddingTop;
  double _paddingBot;
  var format = DateFormat.yMMMd("en_US");
  String code;
  bool _isLoading = false;
  Future<Null> _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return LoginWithProvider();
    }));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _paddingTop = mediaQuery.padding.bottom;
    _paddingBot = mediaQuery.padding.bottom;
    _deviceHeight = mediaQuery.size.height - (_paddingTop + _paddingBot);
    _deviceWidth = mediaQuery.size.width;
    final _auth = Provider.of<LoginState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Things"),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        ///ADD item BUTTON
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          List<String> errorCode = error;
          code = await QR.instance.scanQr();
          if (code == errorCode[0] || code == errorCode[1]) {
            showAlert("Error", code, context, AlertType.error, () {
              Navigator.of(context, rootNavigator: true).pop();
            });
            setState(() {
              _isLoading = false;
            });
          } else if (code == errorCode[2]) {
            setState(() {
              _isLoading = false;
            });
          } else {
            ///check if qr is registered in the database
            QRCode qr = await DBService.instance.getQRCode(code, context);
            if (qr != null) {
              setState(() {
                _isLoading = true;
              });
              print(qr.expiration.toString());
              print(qr.id);
              bool qrExist =
                  await DBService.instance.checkQRUsage(code, context);
              if (qrExist) {
                setState(() {
                  _isLoading = false;
                });
                showAlert("Error", "QR code Already in used", context,
                    AlertType.error, () {
                  Navigator.of(context, rootNavigator: true).pop();
                });
              } else {
                setState(() {
                  _isLoading = false;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddItem(
                              qr: qr,
                              user: _auth.userData,
                            )));
              }
            } else {
              setState(() {
                _isLoading = false;
              });
              showAlert("Error", "Unknown QR code", context, AlertType.error,
                  () {
                Navigator.of(context, rootNavigator: true).pop();
              });
            }
          }
        },
        backgroundColor: Colors.red,
        child: Icon(
          FontAwesomeIcons.plus,
        ),
      ),
      drawer: NavigationDrawer(parentContext: context),
      body: ModalProgressHUD(
        progressIndicator: SpinKitRing(
          size: 70,
          color: Colors.red,
        ),
        inAsyncCall: _isLoading,
        child: StreamBuilder<QuerySnapshot>(
          stream:
              thingsRef.where("user_id", isEqualTo: _auth.user.uid).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SpinKitRing(
                color: Colors.red,
              );
            }
            var things = snapshot.data;
            if (things.documents.length == 0) {
              return NoContent("You do not have things currently register");
            } else {
              List<Thing> myThings = [];
              things.documents.forEach((thing) {
                myThings.add(Thing.fromFireStore(thing));
              });
              return ListView.builder(
                  itemCount: things.documents.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Card(
                          elevation: 5.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: _deviceWidth * .05,
                                vertical: _deviceHeight * .01),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                      myThings[index].name,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .display2
                                          .copyWith(fontSize: 16),
                                    )),

                                    ///item menu
                                    itemMenu(context, myThings[index]),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                GridTile(
                                  child: AspectRatio(
                                    aspectRatio: 5 / 3,
                                    child: Carousel(
                                      autoplay: false,
                                      dotBgColor: Colors.transparent,
                                      images: [
                                        thingImage(myThings[index].images[0],
                                            myThings[index].images),
                                        thingImage(myThings[index].images[1],
                                            myThings[index].images),
                                        thingImage(myThings[index].images[2],
                                            myThings[index].images),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    FittedBox(
                                      child: Text(
                                        "Date Added:${format.format(myThings[index].dateAdded.toDate())}",
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                    ),
                                    FittedBox(
                                      child: Text(
                                          "Expiration:${format.format(myThings[index].expiration.toDate())}",
                                          style: TextStyle(fontSize: 12.0)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                    );
                  });
            }
          },
        ),
      ),
    );
  }

  Widget thingImage(String imageURL, List<String> images) {
    return GestureDetector(
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: imageURL,
        placeholder: (context, url) => SpinKitFadingFour(
          color: Colors.black54,
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ViewImage(images: images, imageURL: imageURL),
                fullscreenDialog: true));
      },
    );
  }
}
