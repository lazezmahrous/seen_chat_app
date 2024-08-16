import 'package:flutter/material.dart';
import 'package:seen/constanc.dart';

void showSnackBarEror(context, String message, int days) {
  days != 0
      ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(days: days),
          backgroundColor: Colors.redAccent,
          content: Text(
            message,
            style: const TextStyle(),
          ),
        ))
      : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            message,
            style: const TextStyle(),
          ),
        ));
}

void showSnackBarBlue(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(),
      ),
      backgroundColor: Constanc.kOrignalColor,
    ),
  );
}
