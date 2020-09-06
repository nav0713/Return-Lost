import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:returnlost/components/alerts.dart';
import 'package:returnlost/components/drawer.dart';
import 'package:returnlost/models/qr.dart';
import 'package:returnlost/models/things.dart';
import 'package:returnlost/models/user.dart';
import 'package:returnlost/screens/owner_details.dart';
import 'package:returnlost/services/database_service.dart';
import 'package:returnlost/services/login_services.dart';
import 'package:returnlost/services/scanner.dart';
import 'package:returnlost/styles.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ScanToReturn extends StatefulWidget {
  @override
  _ScanToReturnState createState() => _ScanToReturnState();
}

class _ScanToReturnState extends State<ScanToReturn> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Return Lost"),
        centerTitle: true,
      ),
      drawer: NavigationDrawer(
      ),
      body: ChangeNotifierProvider.value(
          value: LoginState.instance,
      child: ModalProgressHUD(
        progressIndicator: SpinKitRing(
          color: Colors.red,
        ),
        inAsyncCall: _loading,
        child: Consumer<LoginState>(
          builder: (context, user, child){
            return Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height *.10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async{
                      setState(() {
                        _loading = true;
                      });
                      List<String> errorCode = error;
                      String code;
                      code = await QR.instance.scanQr();
                      if (code == errorCode[0] || code == errorCode[1]) {
                        showAlert("Error", code, context, AlertType.error, () {
                          Navigator.of(context, rootNavigator: true).pop();
                        });
                        setState(() {
                          _loading = false;
                        });
                      } else if (code == errorCode[2]) {
                        setState(() {
                          _loading = false;
                        });
                      }else{
                        QRCode qr = await DBService.instance.getQRCode(code, context);
                        if(qr != null){
                          Thing item = await DBService.instance.getItem(qr.id);
                          User owner = await DBService.instance.getUser(item.userID);
                          if(user.userData.id == item.userID){
                            showAlert("Error", "You cannot return your own", context, AlertType.info,
                                    () {
                                  Navigator.of(context, rootNavigator: true).pop();
                                });
                            setState(() {
                              _loading =  false;
                            });
                          }else{
                            setState(() {
                              _loading = false;
                              Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerDetails(item: item,owner: owner,)));
                            });
                          }
                        }else{
                          setState(() {
                            _loading = false;
                          });
                          showAlert("Error", "Unknown QR code", context, AlertType.error,
                                  () {
                                Navigator.of(context, rootNavigator: true).pop();
                              });
                        }
                      }

                    },
                    child: Image(
                      height: MediaQuery.of(context).size.height * .60,
                      image: AssetImage("images/qr_scan.gif"),
                    ),
                  ),
                  Wrap(children: <Widget>[
                    Text("PLEASE TAP THE IMAGE TO SCAN QR CODE",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black45),),
                  ],),
                ],
              ),
            );
          },
        ),
      ),
      ),
    );
  }
}
