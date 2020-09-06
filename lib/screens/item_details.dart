import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:returnlost/components/thing_image.dart';
import 'package:returnlost/services/navigation_service.dart';
import 'package:returnlost/widgets/view_image.dart';
import '../models/things.dart';

class ItemDetails extends StatelessWidget {
  Thing item;

  ItemDetails({this.item});

  var format = DateFormat.yMMMd("en_US");
  double _deviceHeight;
  double _deviceWidth;
  double _paddingTop;
  double _paddingBot;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _paddingTop = mediaQuery.padding.bottom;
    _paddingBot = mediaQuery.padding.bottom;
    _deviceHeight = mediaQuery.size.height - (_paddingTop + _paddingBot);
    _deviceWidth = mediaQuery.size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: _deviceWidth,
                height: _deviceHeight * .50,
                child: Card(
                  child: Carousel(
                    autoplay: false,
                    dotBgColor: Colors.transparent,
                    images: [
                      thingImage(item.images[0], item.images),
                      thingImage(item.images[1], item.images),
                      thingImage(item.images[2], item.images),
                    ],
                  ),
                ),
              ),
              Container(
                width: _deviceWidth * .85,
                height: _deviceHeight * .38,
                child: Card(
                  elevation: 4,
                  child: Container(
                    padding: EdgeInsets.all(25),
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          dense: true,
                          title: Text(
                            item.name,
                            style: Theme
                                .of(context)
                                .primaryTextTheme
                                .display2,
                          ),
                          subtitle: Text("Name"),
                        ),
                        ListTile(
                          dense: true,
                          title: Text(item.description,
                              style:
                              Theme
                                  .of(context)
                                  .primaryTextTheme
                                  .display2),
                          subtitle: Text("Description"),
                        ),
                        Divider(),
                        ListTile(
                          dense: true,
                          title: item.reward
                              ? Text(item.rewardDescription,
                              style: Theme
                                  .of(context)
                                  .primaryTextTheme
                                  .display2)
                              : Text("No Current Reward",
                              style: Theme
                                  .of(context)
                                  .primaryTextTheme
                                  .display2),
                          subtitle: Text("Reward Description"),
                        ),
                        Divider(),
                        ListTile(
                          dense: true,
                          title: Text(format.format(item.dateAdded.toDate()),
                              style:
                              Theme
                                  .of(context)
                                  .primaryTextTheme
                                  .display2),
                          subtitle: Text("Date Added"),
                        ),
                        Divider(),
                        ListTile(
                          dense: true,
                          title: Text(format.format(item.expiration.toDate()),
                              style:
                              Theme
                                  .of(context)
                                  .primaryTextTheme
                                  .display2),
                          subtitle: Text("QR code expiration"),
                        )
                      ],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


