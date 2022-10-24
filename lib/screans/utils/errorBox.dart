// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

errorBox(
    {required context,
    required String errorTitle,
    required String error,
    runAfterClose}) {
  Platform.isAndroid
      ? showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(errorTitle),
            content: Text(error),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: const Text('close'),
                onPressed: () {
                  Navigator.pop(context);
                  runAfterClose == null ? print('') : runAfterClose();
                },
              ),
            ],
          ),
        )
      : showCupertinoDialog<void>(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(errorTitle),
            content: Text(error),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: const Text('close'),
                onPressed: () {
                  Navigator.pop(context);
                  runAfterClose == null ? print('') : runAfterClose();
                },
              ),
            ],
          ),
        );
}
