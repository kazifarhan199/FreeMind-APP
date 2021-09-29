import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:social/models/users.dart';
import 'package:social/screens/utils/alert.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  raiseError() {
    if (Provider.of<User>(context, listen: false).hasError) {
      showAlertDialog(
          context: context,
          title: Text(Provider.of<User>(context, listen: false).error));
    } else {
      showAlertDialog(context: context, title: Text("Some error occured"));
    }
  }

  postsPageMethod() {
    DefaultTabController.of(context)!.animateTo(1);
  }

  editProfileMethod() {
    Navigator.of(context).pushNamed('/edit_profile');
  }

  editGroupMethod() {
    Navigator.of(context).pushNamed('/edit_group');
  }

  editPassword() {
    Navigator.of(context).pushNamed('/edit_password');
  }

  logoutMethod() async {
    bool success = await Provider.of<User>(context, listen: false).logout();
    if (success) {
    } else {
      raiseError();
    }
  }

  changeThemeMethod(value) {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => postsPageMethod(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          // centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back), onPressed: postsPageMethod),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: editProfileMethod,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            Provider.of<User>(context).imageURL),
                        radius: 30.0,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                      height: 100.0,
                    ),
                    Expanded(
                      child: Text(
                        Provider.of<User>(context).userName,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: editGroupMethod,
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.group_outlined),
                        onPressed: editGroupMethod),
                    SizedBox(
                      width: 10.0,
                      height: 80.0,
                    ),
                    Text("Manage Group"),
                  ],
                ),
              ),
              InkWell(
                onTap: editPassword,
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.lock_outline),
                        onPressed: editPassword),
                    SizedBox(
                      width: 10.0,
                      height: 80.0,
                    ),
                    Text("Change Password"),
                  ],
                ),
              ),
              InkWell(
                onTap: _showLogoutConfirm,
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: _showLogoutConfirm),
                    SizedBox(
                      width: 10.0,
                      height: 80.0,
                    ),
                    Text("Logout"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutConfirm() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.logout),
              SizedBox(
                width: 10.0,
              ),
              Text("Logout"),
              SizedBox(
                width: 60,
              )
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Are you sure you whant Logout ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancle'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                logoutMethod();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
