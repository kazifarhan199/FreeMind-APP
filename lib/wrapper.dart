import 'package:flutter/material.dart';
import 'package:social/models/users.dart';
import 'package:social/screans/home/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:social/screans/Auth/login.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/loading.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool loading = false;

  // false if user is not logged in
  bool isUserLoggedIn() {
    if (Hive.box('userBox').isNotEmpty) {
      User user = Hive.box('userBox').getAt(0) as User;
      if (user.id == 0) {
        return false;
      }
      updateUserProfile();
      user = Hive.box('userBox').getAt(0) as User;
      if (user.id == 0) {
        return false;
      }
      return true;
    }
    return false;
  }

  // Sync local user profile with one on the server
  updateUserProfile() async {
    if (mounted) setState(() => loading = true);
    User user = Hive.box('userBox').getAt(0) as User;
    try {
      User.profile();
    } catch (e) {
      if (mounted)
        errorBox(
            context: context,
            errorTitle: "Error",
            error: e.toString().substring(11));
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Show loading symbol till trying to figure out is user is logged in then
    // return login page if not loggedin else return the home page
    return Loading(
        loading: loading, child: isUserLoggedIn() ? Home() : Login());
  }
}
