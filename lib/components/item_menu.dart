import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:returnlost/services/database_service.dart';
import '../services/navigation_service.dart';
import '../screens/item_details.dart';
import '../screens/edit_item.dart';
import '../components/loading_dialog.dart';
import '../models/things.dart';
///menu for deleting, updating and viewing item
Widget itemMenu(BuildContext context, Thing item) {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  const menuItems = <String>["Details", "Edit", "Delete"];
  final List<PopupMenuItem<String>> _popUpMenuItems = menuItems
      .map((String value) => PopupMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  return PopupMenuButton<String>(
    onSelected: (String newValue) {
      if (newValue == menuItems[0]) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemDetails(
                      item: item,
                    )));
      } else if (newValue == menuItems[1]) {
        NavigationService.instance.navigateToRoute(MaterialPageRoute(
            builder: (context) => EditItem(
                  item: item,
                )));
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Delete Item ?"),
                content: Text("Are you sure you want to delete this item?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("No"),
                    onPressed: () {
                      NavigationService.instance.goBack();
                    },
                  ),
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () async {
                      Dialogs.showLoadingDialog(
                          context, _keyLoader, "deleting item");
                      await DBService.instance.deleteItem(context, item.id);
                    },
                  )
                ],
              );
            });
      }
    },
    itemBuilder: (BuildContext context) => _popUpMenuItems,
  );
}
