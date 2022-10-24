// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:social/models/users.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/textInput.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String userName = '', password = '';
  bool loading = false;

  // Try to login using API, if success go to wrapper (main page)
  Future loginMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      await User.login(userName: userName, password: password);
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

  // Go to register page
  registerMethod() {
    Routing.registerPage(context);
  }

  // Go to reset password page
  resetpasswordMethod() {
    Routing.resetPasswordPage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      fullscreen: true,
      loading: loading,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.headline2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      child: Column(
                        children: [
                          SizedBox(height: 40.0),
                          TextInput(
                            onChanged: (val) => userName = val,
                            labelText: 'User id',
                            initialText: userName,
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 30.0),
                          TextInput(
                            onChanged: (val) => password = val,
                            labelText: 'Password',
                            initialText: password,
                            obscureText: true,
                          ),
                          SizedBox(height: 30.0),
                          ElevatedButton(
                            onPressed: loginMethod,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(" Login "),
                                  Icon(Icons.send),
                                ],
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                elevation: 15.0,
                                // shape: CircleBorder(),
                                padding: EdgeInsets.all(5)),
                          ),
                          SizedBox(height: 70),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: registerMethod,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.create),
                                  Text(" Register"),
                                ],
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                elevation: 15.0,
                                // shape: CircleBorder(),
                                padding: EdgeInsets.all(5)),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextButton(
                            onPressed: resetpasswordMethod,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.lock_outline),
                                  Text(" Reset Password")
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
