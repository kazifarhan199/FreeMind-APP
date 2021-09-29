import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/models/users.dart';
import 'package:social/screens/utils/alert.dart';
import 'package:social/screens/utils/loading.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool loading = false, _isHiddenPassword = true, _isHiddenPasswordre = true;
  String username = '', email = '', password = '', passwordre = '';
  User user = User();

  raiseError() {
    if (Provider.of<User>(context, listen: false).hasError) {
      showAlertDialog(
          context: context,
          title: Text(Provider.of<User>(context, listen: false).error));
    } else {
      showAlertDialog(context: context, title: Text("Some error occured"));
    }
  }

  Future loginMethod() async {
    Navigator.pop(context);
  }

  Future registerMethod() async {
    setState(() => loading = true);
    bool success = await user.register(username, email, password, passwordre);
    if (success) {
      Navigator.pop(context);
    } else {
      raiseError();
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      this.user = Provider.of<User>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        Text(
                          "Register",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        // Email
                        Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextFormField(
                              onChanged: (value) => email = value,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              initialValue: email,
                              decoration: InputDecoration(
                                labelText: "Email",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        // Username
                        Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextFormField(
                              onChanged: (value) => username = value,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              initialValue: username,
                              decoration: InputDecoration(
                                labelText: "Username",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        // Password
                        Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextFormField(
                              onChanged: (value) => password = value,
                              obscureText: _isHiddenPassword,
                              keyboardType: TextInputType.visiblePassword,
                              initialValue: password,
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: InputBorder.none,
                                suffix: InkWell(
                                  child: Icon(
                                    _isHiddenPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _isHiddenPassword = !_isHiddenPassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        // password-re
                        Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextFormField(
                              onChanged: (value) => passwordre = value,
                              obscureText: _isHiddenPasswordre,
                              keyboardType: TextInputType.visiblePassword,
                              initialValue: passwordre,
                              decoration: InputDecoration(
                                labelText: "Password-re",
                                border: InputBorder.none,
                                suffix: InkWell(
                                  child: Icon(
                                    _isHiddenPasswordre
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _isHiddenPasswordre =
                                          !_isHiddenPasswordre;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: registerMethod,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text("Register"),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextButton(
                          onPressed: loginMethod,
                          child: Text("Login"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
