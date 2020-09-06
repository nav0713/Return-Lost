import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/database_service.dart';
import '../components/alerts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';
import 'navigation_service.dart';
import '../components/loading_dialog.dart';

class LoginState extends ChangeNotifier {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final _auth = FirebaseAuth.instance;
  final userRef = Firestore.instance.collection("User");
  LoginState() {
    _checkCurrentUserIsAuthenticated();
  }

  FirebaseUser user;
  User _userData;

  String get userID {
    return user.uid;
  }

  User get userData {
    return _userData;
  }

  static LoginState instance = LoginState();

  Future<void> updateUserImage(String url) async {
    await DBService.instance.updateUserAvatar(user.uid, url);
    userData.image = url;
    notifyListeners();
  }

  Future<void> updateUserName(String name) async {
    await DBService.instance.updateUserName(user.uid, name);
    userData.name = name;
    notifyListeners();
  }

  Future<void> _autoLogin() async {
    if (user != null) {
      _userData = await DBService.instance.getUserData(user.uid);
      return NavigationService.instance.navigateTo("home");
    }
  }

  Future<void> _checkCurrentUserIsAuthenticated() async {
    user = await _auth.currentUser();
    if (user != null) {
      notifyListeners();
      await _autoLogin();
    }
  }

  void logIn(
    BuildContext context,
    String _username,
    String _password,
  ) async {
    String email = _username + "@gmail.com";
    try {
      Dialogs.showLoadingDialog(context, _keyLoader, "Logging in");
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: _password);
      user = result.user;
      _userData = await DBService.instance.getUserData(user.uid);
      print(user.uid);
      notifyListeners();
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      NavigationService.instance.navigateToReplacement("home");
    } on PlatformException catch (e) {
      showAlert("Login Unsuccessful", "Incorrect Username or Password", context,
          AlertType.error, () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      });

    } catch (e) {
      user = null;
      print(e.toString());
    }
    notifyListeners();
  }

  void logoutUser() async {
    try {
      await _auth.signOut();
      user = null;
      await NavigationService.instance.navigateToReplacement("login");
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
