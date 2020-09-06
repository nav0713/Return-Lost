import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

///loading dialogs
class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key, String title) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        SpinKitFadingCircle(
                          color: Colors.red,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          title,
                          style:
                              TextStyle(color: Colors.black87, fontSize: 16.0),
                        )
                      ]),
                    )
                  ]));
        });
  }
}
