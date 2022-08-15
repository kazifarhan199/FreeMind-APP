// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:social/models/users.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/textInput.dart';

class Password extends StatefulWidget {
  const Password({Key? key}) : super(key: key);

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  String password = '', password_re = '';
  bool loading = false;

  Future changePasswordMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      await User.passwordChange(password: password, re_password: password_re);
      Navigator.of(context).pop();
      Routing.wrapperPage(context);
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      loading: loading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("FreeMind"),
          // flexibleSpace: Image(
          //   image: AssetImage('assets/background.png'),
          //   fit: BoxFit.cover,
          // ),
          // backgroundColor: Colors.transparent,
          actions: [
            IconButton(onPressed: changePasswordMethod, icon: Icon(Icons.send)),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                TextInput(
                  onChanged: (val) => password = val,
                  initialText: '',
                  labelText: 'Password',
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextInput(
                  onChanged: (val) => password_re = val,
                  initialText: '',
                  labelText: 'Repeat-Password',
                ),
                SizedBox(height: 60.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
