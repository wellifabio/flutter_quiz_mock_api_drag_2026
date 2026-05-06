import 'package:flutter/material.dart';

abstract class Janelas {
  static void msgDialog(String titulo, String msg, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Image.asset(titulo, width: 120),
        content: Text(msg),
        actions: [
          ElevatedButton(
            key: Key('ok'),
            child: Text("Ok"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
