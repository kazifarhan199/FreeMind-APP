// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, must_be_immutable, file_names

import 'dart:io';

import 'package:hive/hive.dart';
import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:social/models/users.dart';
import 'package:social/models/groups.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/textInput.dart';

class NoGroup extends StatefulWidget {
  const NoGroup({ Key? key }) : super(key: key);

  @override
  State<NoGroup> createState() => _NoGroupState();
}

class _NoGroupState extends State<NoGroup> {
  User user = Hive.box('userBox').getAt(0) as User;
  bool loading=false;
  String name='';

  Future createGroupMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      await GroupModel.createNewGroup(name);
      Routing.wrapperPage(context);
    } on Exception catch( e){
      if (mounted) errorBox(context:context, error:e.toString().substring(11), errorTitle: 'Error'); 
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> refreshMethod() async {
    if (mounted) setState(() => loading = true);
    try{
      await User.profile();
      Routing.wrapperPage(context);
    }on Exception catch(e){
      errorBox(context: context, errorTitle: "Refreshing", error:e.toString().substring(11));
    }
    if (mounted) setState(() => loading = false);
  }

  logoutMethod() async {
    Navigator.pop(context);
    if (mounted) setState(() => loading = true);
    try {
      await User.logout();
      Routing.wrapperPage(context);
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Logout');
    }
    if (mounted) setState(() => loading = false);
  }

  showLogoutAlertMethod() {
    Platform.isAndroid
    ? showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout ?'),
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
        content: const Text('Are you sure you want to logout ?'),
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
        
          appBar: 
          // PreferredSize(
          // preferredSize: Size.fromHeight(100.0),
          // child: 
          AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text("No Group Found", style: TextStyle(fontSize: 30.0)),
            // flexibleSpace: Image(
            //   image: AssetImage('assets/background.png'),
            //   fit: BoxFit.cover,
            // ),
            // backgroundColor: Colors.transparent,
          // ),
        ),
          body: RefreshIndicator(
            onRefresh: refreshMethod,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          """\nYou have not been added to any group yet :(\n
      Please ask your group members to add you in the group\n
      Your email is ${user.email}\n
      Refresh here""",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Tooltip(
                        message: "Refresh",
                        child: IconButton(
                            icon: Icon(
                              Icons.refresh,
                              color: Colors.blue,
                              size: 30.0,
                            ),
                            onPressed: refreshMethod),
                      ),
                      Text(
                        "\n-- OR --\n",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: TextInput(
                            onChanged: (value) => name = value,
                            initialText: name,
                            labelText: 'Group name',
                          ),
                        ),
                      ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: createGroupMethod,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(" Create a new Group  "),
                                Icon(Icons.send),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                      ],
                    ),),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 60.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: showLogoutAlertMethod,
                          style: ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.red)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(" Logout  "),
                                Icon(Icons.lock),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),)

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}