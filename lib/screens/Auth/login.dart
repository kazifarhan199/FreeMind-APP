import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/models/users.dart';
import 'package:social/screens/utils/alert.dart';
import 'package:social/screens/utils/loading.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  String email = '', password = '';
  bool _isHidden = true;
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
    setState(() => loading = true);

    bool success = await user.login(email, password);
    if (success) {
      FocusScope.of(context).unfocus();
    } else {
      raiseError();
    }
    if (mounted) setState(() => loading = false);
  }

  registerMethod() {
    Navigator.pushNamed(context, '/register');
  }

  passwordResetMethod() {
    Navigator.pushNamed(context, '/reset_password');
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
                          "Login",
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
                        // Password
                        Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextFormField(
                              onChanged: (value) => password = value,
                              obscureText: _isHidden,
                              keyboardType: TextInputType.visiblePassword,
                              initialValue: password,
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: InputBorder.none,
                                suffix: InkWell(
                                  child: Icon(
                                    _isHidden
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _isHidden = !_isHidden;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: loginMethod,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 46.0, vertical: 8.0),
                            child: Text("Login"),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextButton(
                          onPressed: passwordResetMethod,
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text("OR"),
                        SizedBox(height: 10.0),
                        TextButton(
                          onPressed: registerMethod,
                          child: Text("Register"),
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
