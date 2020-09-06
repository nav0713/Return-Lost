import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:returnlost/models/qr.dart';
import 'package:returnlost/models/things.dart';
import 'package:returnlost/screens/scan_qr_to_return.dart';
import 'package:returnlost/services/database_service.dart';
import 'package:returnlost/services/navigation_service.dart';
import 'package:returnlost/styles.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../services/login_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/scanner.dart';
import 'alerts.dart';

/// custom drawer
class NavigationDrawer extends StatefulWidget {
  BuildContext parentContext;

  NavigationDrawer({this.parentContext});

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>.value(
      value: LoginState.instance,
      child: NavDrawer(parentContext: widget.parentContext,),
    );
  }
}

class NavDrawer extends StatefulWidget {
  BuildContext parentContext;
  NavDrawer({this.parentContext});
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  bool _loading = true;
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<LoginState>(context);
    return Drawer(
      elevation: 10.0,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    ///USER ACCOUNT INFORMATION SECTION
                    child: UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            ("images/bg.jpg"),
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      accountEmail: Text("Username: ${_auth.userData.username}"),
                      accountName: Text("Name: ${_auth.userData.name}"),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(_auth.userData.image),
                      ),
                    ),
                  ),
                  ///PROFILE MENU
                  menuItem("Profile", FontAwesomeIcons.userAlt, () {
                    NavigationService.instance.navigateTo("profile");
                  }, context),
                  ///HOMEPAGE MENU
                  Divider(),
                  menuItem("My Things", FontAwesomeIcons.suitcaseRolling, () {
                    NavigationService.instance.navigateTo("home");
                  }, context),
                  Divider(),
                  /// RETURN LOST MENU
                  menuItem("Return Lost", FontAwesomeIcons.handsHelping,
                      () async {
                    Navigator.of(context).pop();
Navigator.push(context, MaterialPageRoute(builder: (context) => ScanToReturn()));
                      }, context),
                  Divider(),
                  ///MESSAGES MENU
                  menuItem("Messages", FontAwesomeIcons.facebookMessenger, () {
                    Navigator.of(context).pop();
                    NavigationService.instance.navigateTo("recentChat");
                  }, context),
                  ///NOTIFICATION MENU
                  Divider(),
                  menuItem("Notification", Icons.notifications, () {
                    NavigationService.instance.navigateTo("profile");
                  }, context),
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomLeft,
                      child:
                          ///SIGN OUT BUTTON
                          menuItem("Sign out", FontAwesomeIcons.signOutAlt, () {
                        LoginState.instance.logoutUser();
                      }, context),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget menuItem(
      String label, IconData icon, Function onTap, BuildContext context) {
    return ListTile(
      title: Text(label, style: Theme.of(context).textTheme.subhead),
      leading: Icon(
        icon,
        color: redColor,
      ),
      onTap: onTap,
    );
  }
}
