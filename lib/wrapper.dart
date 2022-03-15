import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:social/models/users.dart';
import 'package:social/routing.dart';
import 'package:social/screans/home/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:social/screans/Auth/login.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/noGroup.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool loading=false;

  bool isUserLoggedIn(){
    if (Hive.box('userBox').isNotEmpty) {
      User user = Hive.box('userBox').getAt(0) as User;
      if (user.id == 0){
        return false;
      }
      updateUserProfile();
      return true;
    }
    return false;
  }

  bool userHasGroup(){
    User user = Hive.box('userBox').getAt(0) as User;
    if (user.gid == 0){
      return false;
    }
    return true;
  }

  updateUserProfile() async {
    User user = Hive.box('userBox').getAt(0) as User;
    try{
      User.profile();
    }catch(e) {
      if (mounted) errorBox(context: context, errorTitle: "Error", error: e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Loading(loading: loading,child: isUserLoggedIn()? userHasGroup()?Home():NoGroup():Login());
  }
}