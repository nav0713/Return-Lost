import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:returnlost/services/database_service.dart';
import 'package:returnlost/services/pick_image.dart';
import 'package:returnlost/styles.dart';
import '../services/cloud_storage_services.dart';
import '../models/things.dart';
import '../models/user.dart';
import '../components/loading_dialog.dart';
import '../models/qr.dart';

class EditItem extends StatefulWidget {
  Thing item;
  EditItem({
    this.item,
  });

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  bool _reward;
  double _deviceHeight;
  double _deviceWidth;
  double _paddingTop;
  double _paddingBot;
  File image1;
  File image2;
  File image3;
  bool _isLoading = false;
  final TextEditingController _rewardDescription = TextEditingController();
  final TextEditingController _itemName = TextEditingController();
  final TextEditingController _itemDescription = TextEditingController();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  void toggleReward(value) {
    setState(() {
      _reward = value;
      if (!_reward) {
        _rewardDescription.clear();
      } else {
        _rewardDescription.text = widget.item.rewardDescription;
      }
    });
  }

  @override
  void initState() {
    setState(() {
      _reward = widget.item.reward;
      _rewardDescription.text = widget.item.rewardDescription;
      _itemName.text = widget.item.name;
      _itemDescription.text = widget.item.description;
    });
    super.initState();
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
        title: Text("Edit Item"),
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
                      controller: _itemName,
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

                    ///item description
                    TextFormField(
                      controller: _itemDescription,
                      maxLines: 4,
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

                    ///reward
                    Row(
                      children: <Widget>[
                        Text("Reward  "),
                        Switch(
                          value: _reward,
                          onChanged: toggleReward,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),

                    ///reward description
                    TextFormField(
                      controller: _rewardDescription,
                      enabled: _reward ? true : false,
                      maxLines: 4,
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
                          ///image1
                          ImageBox(
                            image: image1,
                            imagURL: widget.item.images[0],
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

                          ///image 2
                          ImageBox(
                            image: image2,
                            imagURL: widget.item.images[1],
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

                          ///image 3
                          ImageBox(
                            image: image3,
                            imagURL: widget.item.images[2],
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
                            "Update Item",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: redColor,

                          ///add item button
                          onPressed: () async {
//                            Dialogs.showLoadingDialog(
//                                context, _keyLoader, "Updating Item");
                            if (_formState.currentState.validate()) {
                              if (image1 != null) {
                                widget.item.images[0] =
                                    await CloudStorageService.instance
                                        .uploadFile(widget.item.userID, image1,
                                            "image1");
                              }
                              if (image2 != null) {
                                widget.item.images[1] =
                                    await CloudStorageService.instance
                                        .uploadFile(widget.item.userID, image2,
                                            "image2");
                              }
                              if (image3 != null) {
                                widget.item.images[2] =
                                    await CloudStorageService.instance
                                        .uploadFile(widget.item.userID, image3,
                                            "image3");
                              }
                              Thing newItem = Thing();
                              newItem.id = widget.item.id;
                              newItem.name = _itemName.text;
                              newItem.description = _itemDescription.text;
                              newItem.expiration = widget.item.expiration;
                              newItem.dateAdded = widget.item.dateAdded;
                              newItem.userID = widget.item.userID;
                              newItem.rewardDescription =
                                  _rewardDescription.text;
                              newItem.reward = _reward;
                              newItem.images = [
                                widget.item.images[0],
                                widget.item.images[1],
                                widget.item.images[2],
                              ];
                              await DBService.instance
                                  .updateItem(newItem, context);

                            }
                          }),
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

class ImageBox extends StatelessWidget {
  Function onTap;
  File image;
  String imagURL;
  ImageBox({this.onTap, this.image, this.imagURL});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.grey.withOpacity(.5),
        ),
        child: image == null
            ? CachedNetworkImage(
                imageUrl: imagURL,
                fit: BoxFit.cover,
                placeholder: (context, url) => SpinKitFadingFour(
                  color: Colors.black26,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )
            : Image.file(
                image,
                fit: BoxFit.cover,
              ),
        width: 120,
      ),
    );
  }
}
