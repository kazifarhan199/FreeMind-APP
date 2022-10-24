// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Loading extends StatefulWidget {
  bool loading, fullscreen;
  Widget child;
  Loading(
      {required this.loading,
      this.fullscreen = false,
      required this.child,
      Key? key})
      : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return widget.loading
        ? Scaffold(body: Container(child: Center(child: LoafingInternal())))
        : widget.child;
  }
}

class LoafingInternal extends StatefulWidget {
  const LoafingInternal({Key? key}) : super(key: key);

  @override
  State<LoafingInternal> createState() => _LoafingInternalState();
}

class _LoafingInternalState extends State<LoafingInternal> {
  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? CircularProgressIndicator()
        : CupertinoActivityIndicator(radius: 15);
  }
}
