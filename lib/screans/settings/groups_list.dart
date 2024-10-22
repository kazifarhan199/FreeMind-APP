// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:social/models/users.dart';
import 'package:social/models/groups.dart';
import 'package:social/screans/utils/groupsCard.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/textInput.dart';

class GroupsList extends StatefulWidget {
  const GroupsList({Key? key}) : super(key: key);

  @override
  State<GroupsList> createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  bool loading = false;
  String gName = '';
  User user = Hive.box('userBox').getAt(0) as User;
  List<GroupModel> groups = [];

  Future<void> createGroupMethod() async {
    Navigator.pop(context);

    if (mounted) setState(() => loading = true);
    try {
      await GroupModel.createNewGroup(gName);
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }
    if (mounted) setState(() => loading = false);

    setState(() {
      gName = '';
    });
    await getGroupMethod();
  }

  Future<void> getGroupMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      List<GroupModel> g = await GroupModel.getGroups();
      setState(() {
        groups = g;
      });
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> refreshMethod() async {
    await getGroupMethod();
  }

  @override
  void initState() {
    super.initState();
    getGroupMethod();
  }

  showGroupPopup() {
    Platform.isAndroid
        ? showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Create Group'),
              content: TextInput(
                onChanged: (val) => gName = val,
                labelText: 'Group Name',
                initialText: gName,
                textInputAction: TextInputAction.next,
              ),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('Create'),
                  isDestructiveAction: true,
                  onPressed: createGroupMethod,
                )
              ],
            ),
          )
        : showCupertinoDialog<void>(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Create Group'),
              content: TextInput(
                onChanged: (val) => gName = val,
                labelText: 'User id',
                initialText: gName,
                textInputAction: TextInputAction.next,
              ),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('Create'),
                  isDestructiveAction: true,
                  onPressed: createGroupMethod,
                )
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Groups"),
        actions: [
          IconButton(onPressed: showGroupPopup, icon: Icon(Icons.add)),
        ],
      ),
      body: Loading(
        loading: loading,
        child: RefreshIndicator(
          onRefresh: refreshMethod,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              return GroupsCard(group: groups[index]);
            },
          ),
        ),
      ),
    );
  }
}
