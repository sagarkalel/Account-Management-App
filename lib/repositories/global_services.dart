import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(BuildContext context, String msg) async {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      textColor: Theme.of(context).colorScheme.primary);
}
