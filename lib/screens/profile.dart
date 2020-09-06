import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:returnlost/components/bg_clipper.dart';
import 'package:returnlost/components/drawer.dart';
import 'package:returnlost/services/cloud_storage_services.dart';
import 'package:returnlost/services/login_services.dart';
import 'package:returnlost/styles.dart';
import '../services/database_service.dart';
import 'dart:io';
import '../services/pick_image.dart';

class Profile extends StatelessWidget {
  File avatarImage;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>.value(
      value: LoginState.instance,
      child: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool insAsync = false;
  double _deviceHeight;
  double _deviceWidth;
  double _paddingTop;
  double _paddingBot;
  bool _isLoading = false;
  final _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _paddingTop = mediaQuery.padding.bottom;
    _paddingBot = mediaQuery.padding.bottom;
    _deviceHeight = mediaQuery.size.height - (_paddingTop + _paddingBot);
    _deviceWidth = mediaQuery.size.width;
    final userState = Provider.of<LoginState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      drawer: NavigationDrawer(parentContext: context),
      body: ModalProgressHUD(
        progressIndicator: SpinKitFadingCircle(
          color: redColor,
        ),
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image(
                      fit: BoxFit.cover,
                      height: _deviceHeight * .20,
                      width: _deviceWidth,
                      image: AssetImage("images/user_background.jpg"),
                    ),
                    Positioned(
                      bottom: -50.0,
                      child: Container(
                        width: 120,
                        height: 120.0,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2,color: Colors.white),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: GestureDetector(
                              onTap: () async {
                                File image = await pickImageFunction(context);
                                if (image != null) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  String imageURL = await CloudStorageService.instance
                                      .avatarURL(
                                      userState.user.uid, image, "profileAvatar");
                                  await userState.updateUserImage(imageURL);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                            child: Image(
                              image: CachedNetworkImageProvider(userState.userData.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -60,
                      right: MediaQuery.of(context).size.width * .35,
                      child: IconButton(
                        onPressed: () async {
                          File image = await pickImageFunction(context);
                          if (image != null) {
                            setState(() {
                              _isLoading = true;
                            });
                            String imageURL = await CloudStorageService.instance
                                .avatarURL(
                                userState.user.uid, image, "profileAvatar");
                            await userState.updateUserImage(imageURL);
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        icon: Icon(FontAwesomeIcons.camera,size: 30,color: Colors.black,),),
                    )
                  ],
                ),
                SizedBox(
                  height: _deviceHeight * .10,
                ),
                Container(
                  height: _deviceHeight * .55,
                  width: _deviceWidth * .80,
                  child: Container(
                    child: SingleChildScrollView(
                      child: Card(
                        elevation: 1.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ///username
                            ListTile(
                              dense: true,
                              subtitle: Text(
                                "Name",
                                textAlign: TextAlign.center,
                              ),
                              title: Text(
                                "${userState.userData.name}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                                overflow: TextOverflow.clip,
                                softWrap: true,
                              ),
                            ),
                            SizedBox(
                              width: _deviceWidth * .60,
                              child: Divider(
                                thickness: 1.0,
                              ),
                            ),
                            ListTile(
                              dense: true,
                              subtitle: Text(
                                "Username",
                                textAlign: TextAlign.center,
                              ),
                              title: Text(
                                "${userState.userData.username}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            SizedBox(
                              width: _deviceWidth * .60,
                              child: Divider(
                                thickness: 1.0,
                              ),
                            ),
                            ListTile(
                              dense: true,
                              subtitle: Text(
                                "Thing(s) Registered",
                                textAlign: TextAlign.center,
                              ),
                              title: FutureBuilder<int>(
                                future: DBService.instance.getThingsCount(userState.userData.id),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text("0",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 25));
                                  }
                                  return Text(
                                    "${snapshot.data}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: _deviceWidth * .60,
                              child: Divider(
                                thickness: 1.0,
                              ),
                            ),
                            SizedBox(
                              width: _deviceWidth * .40,
                              child: RaisedButton(
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(
                                        color: redColor, width: 2.0)),
                                onPressed: () {
                                  setState(() {
                                    _nameController.text =
                                        userState.userData.name;
                                  });
                                  showDialog(
                                      context: context,
                                      child: AlertDialog(
                                        content: TextFormField(
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          controller: _nameController,
                                          validator: (input) {
                                            if (input.isEmpty) {
                                              return "Please provide a Name";
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: itemInputStyle()
                                              .copyWith(filled: false),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("Update"),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              if (_nameController.text.length !=
                                                  0) {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                await userState.updateUserName(
                                                    _nameController.text);
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              }
                                            },
                                          )
                                        ],
                                      ));
                                },
                                child: Text(
                                  "Update Name",
                                  style: TextStyle(color: redColor),
                                ),
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: _deviceWidth * .40,
                              child: RaisedButton(
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(
                                        color: redColor, width: 2.0)),
                                onPressed: () {},
                                child: FittedBox(
                                  child: Text(
                                    "Change Password",
                                    style: TextStyle(color: redColor),
                                  ),
                                ),
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
