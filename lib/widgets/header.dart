import 'package:returnlost/components/curve_clipper.dart';
import 'package:flutter/material.dart';
import 'package:returnlost/styles.dart';

Widget header(double high, double wid) {
  return ClipPath(
    clipper: CurveClipper(),
    child: Container(
      width: wid,
      height: high,
      color: redColor,
    ),
  );
}
