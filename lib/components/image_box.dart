import 'package:flutter/material.dart';
import 'dart:io';

/// selecting an item image box
class ImageBox extends StatelessWidget {
  Function onTap;
  File image;
  ImageBox({this.onTap, this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: image == null
            ? Icon(
                Icons.add_a_photo,
                color: Colors.white,
              )
            : Image.file(
                image,
                fit: BoxFit.cover,
              ),
        color: Colors.grey.withOpacity(.5),
        width: 120,
      ),
    );
  }
}
