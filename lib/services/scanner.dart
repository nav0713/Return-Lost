import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

List<String> error = [
  "Camera Permission Denied",
  "UnknownError",
  "You Pressed Back Button"
];

class QR {
  static QR instance = QR();
  Future<String> scanQr() async {
    String result = "";

    try {
      String qrResult = await BarcodeScanner.scan();
      result = qrResult;
    } on PlatformException catch (err) {
      if (err.code == BarcodeScanner.CameraAccessDenied) {
        result = "Camera Permission Denied";
      } else {
        result = "UnknownError";
      }
    } on FormatException {
      result = "You Pressed Back Button";
    } catch (err) {
      result = err;
    }
    return result;
  }
}
