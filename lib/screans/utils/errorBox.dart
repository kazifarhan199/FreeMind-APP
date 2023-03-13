// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/users.dart';
import '../../routing.dart';
import '../../vars.dart';

errorBox(
    {required context,
    required String errorTitle,
    required String error,
    runAfterClose}) {
  if (error == ErrorStrings.loggedout) {
    // This is to log user out if the error is caused because of authentication
    User.logout(delay: 0);
    Navigator.of(context).popUntil((route) => route.isFirst);
    Routing.wrapperPage(context);
  }
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
