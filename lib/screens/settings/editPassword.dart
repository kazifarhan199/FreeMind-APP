import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/models/users.dart';
import 'package:social/screens/utils/alert.dart';
import 'package:social/screens/utils/loading.dart';
import 'package:social/utils/staticStrings.dart';

class EditPassword extends StatefulWidget {
  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  String password = '', passwordre = '';
  bool loading = false, _isHiddenPassword = true, _isHiddenPasswordre = true;

  raiseError() {
    if (Provider.of<User>(context, listen: false).hasError) {
      showAlertDialog(
          context: context,
          title: Text(Provider.of<User>(context, listen: false).error));
    } else {
      showAlertDialog(context: context, title: Text("Some error occured"));
    }
  }

  _changePasswordMethod() async {
    if (mounted) setState(() => loading = true);
    bool success = await Provider.of<User>(context, listen: false)
        .changePassword(password, passwordre);
    if (mounted) setState(() => loading = false);
    if (success) {
      if (success) Navigator.of(context).pop();
    } else {
      raiseError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit Password'),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.check_circle_outline_rounded,
                      size: 40.0,
                    ),
                    onPressed: _changePasswordMethod)
              ],
              // centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
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
                    // confirm password
                    Card(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextFormField(
                          onChanged: (value) => passwordre = value,
                          obscureText: _isHiddenPasswordre,
                          keyboardType: TextInputType.visiblePassword,
                          initialValue: passwordre,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            border: InputBorder.none,
                            suffix: InkWell(
                              child: Icon(
                                _isHiddenPasswordre
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onTap: () {
                                setState(() {
                                  _isHiddenPasswordre = !_isHiddenPasswordre;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Center(
                      child: Text(
                        StaticStrings.password_helper,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
