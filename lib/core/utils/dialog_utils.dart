import 'package:chatbot/main_prod.dart';
import 'package:flutter/material.dart';

showLoadingDialog() {
  showDialog(
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    context: navigatorKey.currentContext!,
    builder: (appContext) {
      return Material(
        color: Colors.grey.withOpacity(0.4),
        child: const SizedBox(
          height: 150,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    },
  );
}

hideLoadingDialog() {
  Navigator.of(navigatorKey.currentContext!).pop();
}
