import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum AlertType {
  success,
  error,
}

class AppHelper {
  static Future<bool?> showAlert(
      {required String message, AlertType alertType = AlertType.error}) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: alertType == AlertType.error ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
