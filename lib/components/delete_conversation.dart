import 'package:flutter/material.dart';
///alert for delete a conversation
Widget deleteDialog(BuildContext context){
  return AlertDialog(
    title: Text("Warning"),
    content: Text("Are you sure you want to delete this note?"),
    actions: <Widget>[
      FlatButton(
        child: Text("Yes"),
        onPressed: () => Navigator.of(context).pop(true),
      ),
      FlatButton(
        child: Text("No"),
        onPressed: () => Navigator.of(context).pop(false),
      )
    ],
  );
}
