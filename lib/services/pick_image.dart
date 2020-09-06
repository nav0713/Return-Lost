import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File> pickImageFunction(BuildContext context) async {
  File image;
  final picker = ImagePicker();
  final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Select the image source"),
            actions: <Widget>[
              RaisedButton.icon(
                color: Colors.redAccent,
                icon: Icon(Icons.camera_enhance),
                label: Text("Camera"),
                onPressed: () => Navigator.pop(context, ImageSource.camera),
              ),
              RaisedButton.icon(
                color: Colors.blueAccent,
                icon: Icon(Icons.photo_library),
                label: Text("Gallery"),
                onPressed: () => Navigator.pop(
                  context,
                  ImageSource.gallery,
                ),
              )
            ],
          ));

  if (imageSource != null) {
    try {
      final file = await picker.getImage(
          source: imageSource,
          maxWidth: 1280.0,
          maxHeight: 720.0,
          imageQuality: 70);
      if (file != null) {
        image = File(file.path);
      } else {
        image = null;
      }
    } catch (e) {
      print(e);
    }
  }
  return image;
}
