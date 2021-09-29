import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/models/users.dart';
import 'package:social/screens/utils/alert.dart';
import 'package:social/screens/utils/loading.dart';
import 'package:social/utils/staticStrings.dart';

class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  bool loading = false, emailTaken = false, otpTaken = false;
  String email = '', otp = '', password = '', passwordre = '';
  bool _isHiddenOTP = true,
      _isHiddenPassword = true,
      _isHiddenPasswordre = true;

  void closeMethod() {
    Navigator.of(context).pop();
  }

  raiseError() {
    if (Provider.of<User>(context, listen: false).hasError) {
      showAlertDialog(
          context: context,
          title: Text(Provider.of<User>(context, listen: false).error));
    } else {
      showAlertDialog(context: context, title: Text("Some error occured"));
    }
  }

  Future getOTPMethod() async {
    setState(() => loading = true);
    bool success =
        await Provider.of<User>(context, listen: false).sendotp(email);
    if (success) {
      emailTaken = true;
    } else {
      raiseError();
    }
    setState(() => loading = false);
  }

  Future checkOTPMethod() async {
    setState(() => loading = true);
    bool success =
        await Provider.of<User>(context, listen: false).varifyotp(email, otp);
    if (success) {
      otpTaken = true;
    } else {
      raiseError();
    }
    setState(() => loading = false);
  }

  Future passwordResetMethod() async {
    setState(() => loading = true);
    bool success = await Provider.of<User>(context, listen: false)
        .passwordreset(email, otp, password, passwordre);
    if (success) {
      Navigator.pop(context);
    } else {
      raiseError();
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    Widget passwordResetWidget = Column(
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
                    _isHiddenPassword ? Icons.visibility : Icons.visibility_off,
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
                labelText: "Password",
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
        SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: passwordResetMethod,
          child: Text("Reset Password"),
        ),
      ],
    );

    return loading
        ? Loading()
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Tooltip(
                        message: "Close",
                        child: IconButton(
                            icon: Icon(Icons.close), onPressed: closeMethod),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 30.0),
                          child: Column(
                            children: [
                              Text(
                                "Reset Password",
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              SizedBox(height: 10.0),
                              emailTaken
                                  ? Row(
                                      children: [
                                        Icon(Icons.check),
                                        SizedBox(width: 10.0),
                                        Text(
                                          email.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Card(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.0),
                                            child: TextFormField(
                                              onChanged: (value) =>
                                                  email = value,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              textInputAction:
                                                  TextInputAction.next,
                                              initialValue: email,
                                              decoration: InputDecoration(
                                                labelText: "Email",
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        ElevatedButton(
                                          onPressed: getOTPMethod,
                                          child: Text("Get OTP"),
                                        ),
                                      ],
                                    ),
                              SizedBox(height: 10.0),
                              emailTaken
                                  ? otpTaken
                                      ? Row(
                                          children: [
                                            Icon(Icons.check),
                                            SizedBox(width: 10.0),
                                            Text(
                                              "OTP",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6,
                                            ),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            Card(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.0),
                                                child: TextFormField(
                                                  onChanged: (value) =>
                                                      otp = value,
                                                  obscureText: _isHiddenOTP,
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  initialValue: password,
                                                  decoration: InputDecoration(
                                                    labelText: "OTP",
                                                    border: InputBorder.none,
                                                    suffix: InkWell(
                                                      child: Icon(
                                                        _isHiddenOTP
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off,
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          _isHiddenOTP =
                                                              !_isHiddenOTP;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10.0),
                                            ElevatedButton(
                                              onPressed: checkOTPMethod,
                                              child: Text("Check OTP"),
                                            ),
                                          ],
                                        )
                                  : Container(),
                              SizedBox(height: 10.0),
                              emailTaken
                                  ? otpTaken
                                      ? passwordResetWidget
                                      : Container()
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
