import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:returnlost/services/database_service.dart';
import 'package:returnlost/services/pick_image.dart';
import 'package:returnlost/styles.dart';
import '../components/image_box.dart';
import '../services/cloud_storage_services.dart';
import '../models/things.dart';
import '../models/user.dart';
import '../components/loading_dialog.dart';
import '../models/qr.dart';

class AddItem extends StatefulWidget {
  User user;
  QRCode qr;
  AddItem({this.user, this.qr});

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  bool _reward = true;
  double _deviceHeight;
  double _deviceWidth;
  double _paddingTop;
  double _paddingBot;
  File image1;
  File image2;
  File image3;
  bool _isLoading = false;
  String _itemName;
  String _itemDescription;
  String _itemRewardDescription;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  void toggleReward(value) {
    setState(() {
      _reward = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _paddingTop = mediaQuery.padding.bottom;
    _paddingBot = mediaQuery.padding.bottom;
    _deviceHeight = mediaQuery.size.height - (_paddingTop + _paddingBot);
    _deviceWidth = mediaQuery.size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Item"),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        progressIndicator: SpinKitFadingCircle(
          size: 70.0,
          color: redColor,
        ),
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.only(left: 25, right: 25, bottom: 10.0, top: 25),
            child: Container(
              child: Form(
                key: _formState,
                onChanged: () {
                  _formState.currentState.save();
                },
                child: Column(
                  children: <Widget>[
                    /// item name
                    TextFormField(
                      onSaved: (input) {
                        _itemName = input;
                      },
                      decoration: itemInputStyle(),
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Please enter a name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      maxLines: 4,
                      onSaved: (input) {
                        _itemDescription = input;
                      },
                      decoration: itemInputStyle().copyWith(
                        hintText: "Enter Item Decrption",
                        labelText: "Description",
                      ),
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Please enter item description";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text("Reward  "),
                        Switch(
                          activeColor: redColor,
                          value: _reward,
                          onChanged: toggleReward,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      enabled: _reward ? true : false,
                      maxLines: 4,
                      onSaved: (input) {
                        _itemRewardDescription = input;
                      },
                      decoration: itemInputStyle().copyWith(
                        hintText: "Enter Reward Description",
                        labelText: "Reward description",
                      ),
                      validator: (input) {
                        if (input.isEmpty && _reward) {
                          return "Please enter reward descrption";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 120.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          ImageBox(
                            image: image1,
                            onTap: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              File img = await pickImageFunction(context);
                              setState(() {
                                image1 = img;
                                _isLoading = false;
                              });
                            },
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          ImageBox(
                            image: image2,
                            onTap: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              File img = await pickImageFunction(context);
                              setState(() {
                                image2 = img;
                                _isLoading = false;
                              });
                            },
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          ImageBox(
                            image: image3,
                            onTap: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              File img = await pickImageFunction(context);
                              setState(() {
                                image3 = img;
                                _isLoading = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      width: _deviceWidth * .80,
                      height: 42,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Add Item",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: redColor,

                        ///add item button
                        onPressed: () async {
                          Dialogs.showLoadingDialog(
                              context, _keyLoader, "Adding new item");
                          if (image1 == null ||
                              image2 == null ||
                              image3 == null) {
                            Fluttertoast.showToast(
                                msg: "Please fill all image boxes",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            if (_formState.currentState.validate()) {
                              String imageurl1 = await CloudStorageService
                                  .instance
                                  .uploadFile(widget.user.id, image1, "image1");
                              String imageurl2 = await CloudStorageService
                                  .instance
                                  .uploadFile(widget.user.id, image2, "image2");
                              String imageurl3 = await CloudStorageService
                                  .instance
                                  .uploadFile(widget.user.id, image3, "image3");
                              Thing newItem = Thing();
                              newItem.name = _itemName;
                              newItem.description = _itemDescription;
                              newItem.expiration = widget.qr.expiration;
                              newItem.dateAdded =
                                  Timestamp.fromDate(DateTime.now());
                              newItem.userID = widget.user.id;
                              newItem.rewardDescription =
                                  _itemRewardDescription;
                              newItem.reward = _reward;
                              newItem.images = [
                                imageurl1,
                                imageurl2,
                                imageurl3
                              ];
                              await DBService.instance
                                  .addItem(newItem, context, widget.qr);
                            }
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
