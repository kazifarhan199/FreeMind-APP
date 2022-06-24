// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:hive/hive.dart';
import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:social/models/users.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/textInput.dart';
import 'package:social/screans/utils/imagePicker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user = Hive.box('userBox').getAt(0) as User;
  final ImagePicker _picker = ImagePicker();
  String email = '', userName = '', bio='';
  File? image;
  bool loading = false;

  Future saveProfileMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      await User.profileEdit(email: email, userName: userName, bio:bio, image: image);
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
  void initState() {
    super.initState();
    email = user.email;
    bio = user.bio;
    userName = user.userName;
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      loading: loading,
      fullscreen: true,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Edit Profile"),
          // flexibleSpace: Image(
          //   image: AssetImage('assets/background.png'),
          //   fit: BoxFit.cover,
          // ),
          // backgroundColor: Colors.transparent,
          actions: [
            IconButton(onPressed: saveProfileMethod, icon: Icon(Icons.send)),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30.0),
                Center(
                  child: InkWell(
                    onTap: fromWhereChooser,
                    child: CircleAvatar(
                      backgroundImage: image == null
                          ? NetworkImage(user.imageUrl)
                          : FileImage(image!) as ImageProvider,
                      radius: 120.0,
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                // Email
                TextInput(
                  onChanged: (val) => email = val,
                  initialText: user.email,
                  labelText: 'Email',
                ),
                // UserName
                SizedBox(
                  height: 20.0,
                ),
                TextInput(
                  onChanged: (val) => userName = val,
                  initialText: user.userName,
                  labelText: 'User id',
                ),
                SizedBox(height: 30.0),
                // bio
                TextInput(
                  onChanged: (val) => bio = val,
                  initialText: user.bio,
                  labelText: 'Bio',
                ),
                SizedBox(
                  height: 40.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
