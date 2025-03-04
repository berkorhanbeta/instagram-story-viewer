import 'package:flutter/material.dart';

class Toast {

  void showSnackBar(BuildContext context, String message, {bool isError = false}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

}