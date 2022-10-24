// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_init_to_null

import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  String? initialText, labelText;
  int? maxlength = null, maxlines = 1;
  TextInputType keyboardtype = TextInputType.text;
  dynamic onChanged;
  TextEditingController? controller;
  bool obscureText = false;
  var textInputAction;

  TextInput(
      {this.initialText,
      this.labelText,
      this.maxlength = null,
      this.keyboardtype = TextInputType.text,
      this.maxlines = 1,
      this.onChanged,
      this.controller,
      this.obscureText = false,
      this.textInputAction,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      initialValue: initialText,
      keyboardType: keyboardtype,
      maxLength: maxlength,
      maxLines: maxlines,
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
