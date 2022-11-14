import 'package:flutter/material.dart';
import 'package:social/models/users.dart';
import 'package:social/routing.dart';
import 'package:social/screans/home/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:social/screans/Auth/login.dart';
import 'package:social/screans/settings/survey.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/loading.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool loading = true;

  // false if user is not logged in
  bool isUserLoggedIn() {
    if (Hive.box('userBox').isNotEmpty) {
      User user = Hive.box('userBox').getAt(0) as User;
      if (user.id == 0) {
        return false;
      }
      return true;
    }
    return false;
  }

  // Sync local user profile with one on the server
  updateUserProfile() async {
    User user = Hive.box('userBox').getAt(0) as User;
    try {
      await User.profile();
    } catch (e) {
      if (mounted)
        errorBox(
            context: context,
            errorTitle: "Error",
            error: e.toString().substring(11));
    }
  }

  bool userHasGivenSurvey() {
    User user = Hive.box('userBox').getAt(0) as User;
    if (user.surveyGiven) {
      return true;
    }
    return false;
  }

  init() async {
    User user = Hive.box('userBox').getAt(0) as User;
    print(user.surveyGiven);
    print("In init function wrapper");
    print(userHasGivenSurvey());
    if (await isUserLoggedIn()) {
      if (userHasGivenSurvey()) {
        Routing.homePage(context);
      } else {
        Routing.SurveyPage(context);
      }
    } else {
      Routing.loginPage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    // Show loading symbol till trying to figure out is user is logged in then
    // return login page if not loggedin else return the home page
    return Loading(
        loading: loading,
        child: Scaffold(
          body: Container(),
        ));
  }
}
