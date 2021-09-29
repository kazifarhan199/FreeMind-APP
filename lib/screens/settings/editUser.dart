import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/models/users.dart';
import 'package:social/screens/utils/alert.dart';
import 'package:social/screens/utils/image.dart';
import 'package:social/screens/utils/loading.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String email = '', username = '', firstname = '', lastname = '';
  bool loading = false;
  File? _image;

  raiseError() {
    if (Provider.of<User>(context, listen: false).hasError) {
      showAlertDialog(
          context: context,
          title: Text(Provider.of<User>(context, listen: false).error));
    } else {
      showAlertDialog(context: context, title: Text("Some error occured"));
    }
  }

  Future saveUserMethod() async {
    if (mounted) setState(() => loading = true);
    bool success = await Provider.of<User>(context, listen: false)
        .edit(username, email, _image);
    if (mounted) setState(() => loading = false);

    if (success) {
      Navigator.of(context).pop();
    } else {
      raiseError();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future _getImageMethod() async {
    getImageMethod(
        context: context,
        callback: (img) => setState(() => _image = img),
        square: true);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit Profile'),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.check_circle_outline_rounded,
                      size: 40.0,
                    ),
                    onPressed: saveUserMethod)
              ],
              // centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Center(
                      child: InkWell(
                        onTap: _getImageMethod,
                        child: CircleAvatar(
                          backgroundImage: _image == null
                              ? NetworkImage(
                                  Provider.of<User>(context).imageURL)
                              : FileImage(_image!) as ImageProvider,
                          radius: 60.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    // Email
                    Card(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextFormField(
                          onChanged: (value) => email = value,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          initialValue:
                              Provider.of<User>(context, listen: false).email,
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    // UserName
                    Card(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextFormField(
                          onChanged: (value) => username = value,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          initialValue:
                              Provider.of<User>(context, listen: false)
                                  .userName,
                          decoration: InputDecoration(
                            labelText: "Username",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
