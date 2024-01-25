import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  String text,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.up,
      margin: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).size.height - 150),
      content: Text(text),
    ),
  );
}
