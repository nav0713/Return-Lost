import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const redColor = Color(0xffb61c1c);
TextStyle otpInput() {
  return TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: "Karla",
      fontSize: 20.0,
      letterSpacing: 2.0);
}

TextStyle btnTextStyle() {
  return TextStyle(
      color: Colors.white,
      fontFamily: "Quicksand",
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5);
}

InputDecoration itemInputStyle() {
  return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54, width: 0)),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54, width: 0)),
      filled: true,
      hintText: "Enter Item Name",
      labelText: "Name");
}

InputDecoration inputStyle(BuildContext context, IconData icon) {
  return InputDecoration(
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black54, width: 0)),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black54, width: 0)),
    hintText: "Password",
    prefixIcon: Icon(icon, color: redColor),
  );
}
