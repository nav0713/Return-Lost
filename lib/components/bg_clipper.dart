import 'package:flutter/material.dart';

class BGClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height*.8);
    Offset curvePoint =Offset(size.width / 2, size.height);
    Offset endPoint = Offset(size.width, size.height * .8);
    path.quadraticBezierTo(curvePoint.dx, curvePoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height * .8);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

}