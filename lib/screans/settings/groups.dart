// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:social/models/users.dart';
import 'package:social/models/groups.dart';
import 'package:social/screans/utils/imagePicker.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/textInput.dart';
import 'package:social/screans/utils/memberCard.dart';

class Group extends StatefulWidget {
  int gid;
  bool doublePop;
  Group({required this.gid, this.doublePop = true, Key? key}) : super(key: key);

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

  File? image;

  Future<void> saveGroupMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      await group.editGroup(name: _name, gid: widget.gid, image: image);
      Navigator.of(context).pop();
      if (widget.doublePop) {
        Navigator.of(context).pop();
      }
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

  getImageMethod(String fromWhere) async {
    XFile? localImage;
    if (fromWhere == 'camera') {
      localImage = await getImageFromCamera(context);
    } else if (fromWhere == 'photos') {
      localImage = await getImageFromPhtos(context);
    }
    if (localImage != null) {
      if (mounted) setState(() => image = File(localImage!.path));
    }
  }

  Future<void> getGroupMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      group = await GroupModel.getGroup(gid: widget.gid);
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

  Future<void> addUserMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      List<membersModel> localMemebers = await group.addMember(
          email: _email, group: user.gid, gid: widget.gid);
      setState(() => members = localMemebers);
      setState(() => _email = '');
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }
    await getGroupMethod();
    if (mounted) setState(() => loading = false);
  }

  Future<void> removeMemberMethod(String email) async {
    if (mounted) setState(() => loading = true);
    try {
      List<membersModel> localMemebers = await group.removeMember(
          email: email, group: user.gid, gid: widget.gid);
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

  fromWhereChooser() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Image from'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.camera), Text('  Camera')],
            ),
            onPressed: () {
              Navigator.pop(context);
              getImageMethod('camera');
            },
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.photo), Text('  Photos')],
            ),
            onPressed: () {
              Navigator.pop(context);
              getImageMethod('photos');
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Cancle'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Group"),
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
          onRefresh: () async {
            getGroupMethod();
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 15.0),
                  InkWell(
                      onTap: () => fromWhereChooser(),
                      child: CircleAvatar(
                        backgroundImage: image == null
                            ? NetworkImage(group.imageUrl)
                            : FileImage(image!) as ImageProvider,
                        radius: 130.0,
                      )),
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
                    labelText: 'Email/Username',
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
