// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:social/models/users.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/textInput.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String userName='', email='', password='', password_re='';
  bool loading=false;

  Future RegisterMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      await User.register(userName:userName, password:password, re_password:password_re, email: email);
      Navigator.of(context).pop();
      Routing.wrapperPage(context);
    } on Exception catch( e){
      if (mounted) errorBox(context:context, error:e.toString().substring(11), errorTitle: 'Error'); 
    }
    if (mounted) setState(() => loading = false);
  }
  
  loginMethod() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      fullscreen:true,
      loading: loading,
      child: Scaffold(
// appBar: 
// PreferredSize(
//           preferredSize: Size.fromHeight(100.0),
          // child: 
          // AppBar(
          //   centerTitle: true,
          //   title: Text("Register", style: GoogleFonts.laila(fontSize: 35.0)),
            // flexibleSpace: Image(
            //   image: AssetImage('assets/background.png'),
            //   fit: BoxFit.cover,
            // ),
            // backgroundColor: Colors.transparent,
          // ),
        // ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                SizedBox(height:60),
                Text(
                          "Register",
                          style: Theme.of(context).textTheme.headline2,
                        ),
              Container(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    TextInput(
                      onChanged: (val) => userName = val,
                      labelText: 'User id',
                      initialText: userName,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 30.0),
                    TextInput(
                      onChanged: (val) => email = val,
                      labelText: 'Email',
                      initialText: email,
                      keyboardtype: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 30.0),
                    TextInput(
                      onChanged: (val) => password = val,
                      labelText: 'Password',
                      initialText: '',
                      obscureText:true,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 30.0),
                    TextInput(
                      onChanged: (val) => password_re = val,
                      labelText: 'Repeat-Password',
                      initialText: '',
                      obscureText:true,
                    ),
                    SizedBox(height: 30.0),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: RegisterMethod,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(" Register  "),
                                Icon(Icons.send),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),),
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
