import '../styles.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
/// class for custom alert diaglogs
void showAlert(String label, String desc, BuildContext context,
    AlertType alertType, Function onPressed) {
  Alert(
    context: context,
    type: alertType,
    title: label,
    desc: desc,
    style: AlertStyle(
      isCloseButton: false,
    ),
    buttons: [
      DialogButton(
        color: redColor,
        onPressed: onPressed,
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        width: 120,
      )
    ],
  ).show();
}
