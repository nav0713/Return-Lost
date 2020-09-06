import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

enum AuthStatus {
  NotAuthenticated,
  Authenticating,
  Authenticated,
  UserNotFound,
  Error,
}

class AuthProvider extends ChangeNotifier {
  FirebaseUser user;
  FirebaseAuth _auth;
  AuthStatus status;
  User userData;
  final userRef = Firestore.instance.collection("User");
  AuthProvider() {
    _auth = FirebaseAuth.instance;
    // _checkCurrentUserIsAuthenticated();
  }

  static AuthProvider instance = AuthProvider();

  Future<void> _autoLogin() async {
    if (user != null) {
      print("already login");
    }
  }

  void _checkCurrentUserIsAuthenticated() async {
    user = await _auth.currentUser();
    if (user != null) {
      notifyListeners();
      await _autoLogin();
    }
  }

  void loginUserWithEmailAndPassword(String _email, String _password) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      AuthResult _result = await _auth.signInWithEmailAndPassword(
          email: _email + "@gmail.com", password: _password);
      user = _result.user;
      if (user != null) {
        status = AuthStatus.Authenticated;
      }
    } catch (e) {
      status = AuthStatus.Error;
      user = null;
    }
    notifyListeners();
  }
}
