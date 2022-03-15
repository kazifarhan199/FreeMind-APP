// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:social/models/users.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/textInput.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => RresetPasswordState();
}

class RresetPasswordState extends State<ResetPassword> {
  String email = '', otp = '', password = '', password_re = '';
  bool hasEmail = false, loading = false;

  Future ResetPasswordMethod() async {
    if (mounted) setState(() => loading = true);
    if (hasEmail == false) {
      try {
        await User.sendPasswordResetEmail(email: email);
        setState(() => hasEmail = true);
      } on Exception catch (e) {
        if (mounted)
          errorBox(
              context: context,
              error: e.toString().substring(11),
              errorTitle: 'Error');
      }
    } else {
      try {
        await User.passwordReset(
            otp: otp,
            email: email,
            password: password,
            re_password: password_re);
        setState(() => hasEmail = true);
      } on Exception catch (e) {
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
      }
    }
    if (mounted) setState(() => loading = false);
  }

  loginMethod() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      fullscreen: true,
      loading: loading,
      child: Scaffold(
        // appBar: 
        // PreferredSize(
        //   preferredSize: Size.fromHeight(100.0),
        //   child: 
          // AppBar(
          //   centerTitle: true,
          //   title: Text("Reset Password",
          //       style: GoogleFonts.laila(fontSize: 35.0)),
            // flexibleSpace: Image(
            //   image: AssetImage('assets/background.png'),
            //   fit: BoxFit.cover,
            // ),
            // backgroundColor: Colors.transparent,
          // ),
        // ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                              SizedBox(height:60),
                Center(
                  child: Text(
                            "Reset Password",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                ),
              Container(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    hasEmail == true
                        ? Container()
                        : Column(children: [
                            TextInput(
                                onChanged: (val) => email = val,
                                labelText: 'Email',
                                initialText: email,
                                keyboardtype: TextInputType.emailAddress),
                            SizedBox(height: 50.0),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 40.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: ResetPasswordMethod,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(" Reset Password  "),
                                          Icon(Icons.send),
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
                                ],
                              ),
                            ),
                          ]),
                    hasEmail == false
                        ? Container()
                        : Column(children: [
                            SizedBox(height: 30.0),
                            TextInput(
                              onChanged: (val) => otp = val,
                              labelText: 'OTP',
                              keyboardtype: TextInputType.number,
                              initialText: otp,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 20.0),
                            TextInput(
                              onChanged: (val) => password = val,
                              labelText: 'Password',
                              initialText: '',
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 20.0),
                            TextInput(
                              onChanged: (val) => password_re = val,
                              labelText: 'Repeat-Password',
                              initialText: '',
                              obscureText: true,
                            ),
                            SizedBox(height: 50.0),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 40.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: ResetPasswordMethod,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(" Reset Password  "),
                                          Icon(Icons.send),
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
                                ],
                              ),
                            ),
                          ]),
                    SizedBox(
                      height: 40.0,
                    ),
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon(Icons.lock_outline),
                                  Text("Login")
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
