import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/common/navigation.dart';

customDialog(BuildContext context) {
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Segera Hadir!'),
            content: const Text('Fitur ini akan segera hadir!'),
            actions: [
              CupertinoDialogAction(
                  child: const Text('OK'), onPressed: () => Navigation.back())
            ],
          );
        });
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Segera Hadir!'),
            content: const Text('Fitur ini akan segera hadir!'),
            actions: [
              TextButton(
                  onPressed: () => Navigation.back(), child: const Text('OK'))
            ],
          );
        });
  }
}
