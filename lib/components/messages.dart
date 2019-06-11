import 'package:flutter/material.dart';

showSuccessMessage(String message, BuildContext context) {
  Scaffold.of(context).showSnackBar(new SnackBar(
    content: new Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.green,
  ));
}

showErrorMessage(String message, BuildContext context) {
  Scaffold.of(context).showSnackBar(new SnackBar(
    content: new Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
  ));
}

showMessage(String message, BuildContext context) {
  Scaffold.of(context).showSnackBar(new SnackBar(
    content: new Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.blue,
  ));
}
