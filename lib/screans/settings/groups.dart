// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:hive/hive.dart';
import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:social/models/users.dart';
import 'package:social/models/groups.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/textInput.dart';
import 'package:social/screans/utils/memberCard.dart';

class Group extends StatefulWidget {
  const Group({Key? key}) : super(key: key);

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
  bool loading = false;
  String _email = '';
  String _name = '';
  GroupModel group = GroupModel.fromJson({});
  User user = Hive.box('userBox').getAt(0) as User;
  List<membersModel> members = [];

  getGroupMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      group = await GroupModel.getGroup();
      setState(() => members = group.members);
      setState(() => _name = group.name);
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }
    if (mounted) setState(() => loading = false);
  }

  saveGroupMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      await group.editGroup(name: _name);
      Navigator.of(context).pop();
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

  addUserMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      List<membersModel> localMemebers = await group.addMember(email: _email);
      setState(() => members = localMemebers);
      setState(() => _email = '');
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }
    if (mounted) setState(() => loading = false);
  }

  removeMemberMethod(String email) async {
    if (mounted) setState(() => loading = true);

    try {
      List<membersModel> localMemebers = await group.removeMember(email: email);
      setState(() => members = localMemebers);
      if (user.email == email) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Routing.wrapperPage(context);
      }
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }

    if (mounted) setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    getGroupMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Group"),
        // flexibleSpace: Image(
        //   image: AssetImage('assets/background.png'),
        //   fit: BoxFit.cover,
        // ),
        // backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: _email == '' ? saveGroupMethod : addUserMethod,
            icon: _email == '' ? Icon(Icons.send) : Icon(Icons.add),
          ),
        ],
      ),
      body: Loading(
        loading: loading,
        child: RefreshIndicator(
          onRefresh: () async {},
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 15.0),
                  TextInput(
                    initialText: _name,
                    labelText: "Group Name",
                    onChanged: (val) => _name = val,
                  ),
                  // Email
                  SizedBox(height: 30.0),
                  Text("Add a new group member"),
                  SizedBox(height: 20.0),
                  TextInput(
                    initialText: _email,
                    labelText: 'Email',
                    onChanged: (val) => setState(() => _email = val),
                  ),
                  SizedBox(height: 20.0),
                  Text("Group Members"),
                  SizedBox(height: 10.0),
                  SizedBox(
                    height: 80 *
                        members.length.toDouble(), // increase this with length
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        return MemeberCard(
                            member: members[index],
                            removeMemberMethod: removeMemberMethod);
                      },
                    ),
                  ),
                  SizedBox(height: 50.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
