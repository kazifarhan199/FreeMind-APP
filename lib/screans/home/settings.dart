// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:hive/hive.dart';
import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:social/models/users.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/vars.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  User user = Hive.box('userBox').getAt(0) as User;
  bool loading = false;

  logoutMethod() async {
    Navigator.pop(context);
    if (mounted) setState(() => loading = true);
    try {
      await User.logout();
      Navigator.of(context).pop();
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

  profileEditMethod() {
    Routing.profileEditPage(context);
  }

  passwordMethod() {
    Routing.passwordPage(context);
  }

  groupMethod() {
    Routing.groupsPage(context);
  }

  surveyMethod() {
    Routing.SurveyPage(context);
  }

  channelsMethod(){
    Routing.ChannelsPage(context);
  }

  showLogoutAlertMethod() {
    Platform.isAndroid
    ? showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Logout'),
        content: Text(InfoStrings.logout_info),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            child: const Text('Yes'),
            isDestructiveAction: true,
            onPressed: logoutMethod,
          )
        ],
      ),
    )
    :showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Logout'),
        content: Text(InfoStrings.logout_info),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            child: const Text('Yes'),
            isDestructiveAction: true,
            onPressed: logoutMethod,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      loading: loading,
      fullscreen: true,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Settings"),
          // flexibleSpace: Image(
          //   image: AssetImage('assets/background.png'),
          //   fit: BoxFit.cover,
          // ),
          // backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: profileEditMethod,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.imageUrl),
                        radius: 30.0,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                      height: 100.0,
                    ),
                    Expanded(
                      child: Text(
                        user.userName,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: groupMethod,
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.group_outlined),
                        onPressed: groupMethod),
                    SizedBox(
                      width: 10.0,
                      height: 80.0,
                    ),
                    Text("Manage Group"),
                  ],
                ),
              ),
              InkWell(
                onTap: passwordMethod,
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.lock_outline),
                        onPressed: passwordMethod),
                    SizedBox(
                      width: 10.0,
                      height: 80.0,
                    ),
                    Text("Change Password"),
                  ],
                ),
              ),
              InkWell(
                onTap: surveyMethod,
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.question_answer),
                        onPressed: surveyMethod),
                    SizedBox(
                      width: 10.0,
                      height: 80.0,
                    ),
                    Text("Survey"),
                  ],
                ),
              ),
              InkWell(
                onTap: channelsMethod,
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.group),
                        onPressed: channelsMethod),
                    SizedBox(
                      width: 10.0,
                      height: 80.0,
                    ),
                    Text("Channels"),
                  ],
                ),
              ),
              InkWell(
                onTap: showLogoutAlertMethod,
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: showLogoutAlertMethod),
                    SizedBox(
                      width: 10.0,
                      height: 80.0,
                    ),
                    Text("Logout"),
                  ],
                ),
              ),
              InkWell(
                onTap: (){},
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.info),
                        onPressed: showLogoutAlertMethod),
                    SizedBox(
                      width: 10.0,
                      height: 80.0,
                    ),
                    Text(app_version),
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
