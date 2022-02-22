import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/models/member.dart';
import 'package:social/models/users.dart';
import 'package:social/screens/utils/alert.dart';
import 'package:social/screens/utils/groupmemberCard.dart';
import 'package:social/screens/utils/loading.dart';

class EditGroup extends StatefulWidget {
  const EditGroup({Key? key}) : super(key: key);

  @override
  _EditGroupState createState() => _EditGroupState();
}

class _EditGroupState extends State<EditGroup> {
  String email = '', groupName = '';
  Map<String, Widget> membersToAddMap = {}, groupMembers = {};
  List members = [];
  final emailControler = TextEditingController();
  bool loading = false;
  int pkinternalID = 0;
  final groupNameController = TextEditingController();

  raiseError() {
    if (Provider.of<User>(context, listen: false).hasError) {
      showAlertDialog(
          context: context,
          title: Text(Provider.of<User>(context, listen: false).error));
    } else {
      showAlertDialog(context: context, title: Text("Some error occured"));
    }
  }

  saveGroupMethod() async {
    if (mounted) setState(() => loading = true);
    print("Here");
    List<String> emails = membersToAddMap.keys.toList();
    print(emails);
    bool success = await Provider.of<User>(context, listen: false)
        .editGroup(emails, groupName);

    if (success) {
      Navigator.pop(context);
    } else {
      raiseError();
    }
    if (mounted) setState(() => loading = false);
  }

  varifyUserMethod() async {
    if (mounted) setState(() => loading = true);
    Member newMember = await Provider.of<User>(context, listen: false)
        .varifyGroupMember(email);

    if (Provider.of<User>(context, listen: false).hasError) {
      raiseError();
    } else {
      setState(() {
        membersToAddMap[email] =
            GroupMemberCard(newMember, email, removeUserFromMemberToAdd);
      });
      FocusScope.of(context).unfocus();
      emailControler.text = '';
      email = '';
    }
    if (mounted) setState(() => loading = false);
  }

  removeUserFromMemberToAdd(email) {
    if (mounted) setState(() => loading = true);
    if (mounted)
      setState(() {
        membersToAddMap.remove(email);
      });
    if (mounted) setState(() => loading = false);
  }

  removeUserFromGroup(email) async {
    if (mounted) setState(() => loading = true);
    bool success = await Provider.of<User>(context, listen: false)
        .groupRemoveMember(email);
    if (success) {
      setState(() {
        groupName = Provider.of<User>(context, listen: false).groupName;
        members = Provider.of<User>(context, listen: false).members;
        if (mounted)
          setState(() {
            groupMembers.remove(email);
                    if (email == Provider.of<User>(context, listen: false).email ){
          Provider.of<User>(context, listen: false).profile();
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/');
        }
          });
      });
      if (mounted) setState(() => loading = false);
    }
  }

  getGroup() async {
    if (mounted)
      setState(() {
        loading = true;
      });
    bool success = await Provider.of<User>(context, listen: false).getGroup();
    if (success) {
      setState(() {
        groupName = Provider.of<User>(context, listen: false).groupName;
        members = Provider.of<User>(context, listen: false).members;
        groupNameController.text = groupName;
      });
      for (var member in members) {
        if (mounted)
          setState(() {
            groupMembers[member.email] =
                GroupMemberCard(member, member.email, (email) {
              removeUserFromGroup(email);
            });
          });
      }
    } else {
      raiseError();
    }
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  init() async {
    await getGroup();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit Group'),
              actions: [
                email == ''
                    ? Tooltip(
                        message: "Save",
                        child: IconButton(
                            icon: Icon(
                              Icons.check_circle_outline_rounded,
                              size: 40.0,
                            ),
                            onPressed: saveGroupMethod),
                      )
                    : Tooltip(
                        message: "Add comment",
                        child: IconButton(
                            icon: Icon(Icons.add), onPressed: varifyUserMethod),
                      )
              ],
              // centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10.0),
                    Text("Group Name"),
                    SizedBox(height: 10.0),
                    // GroupName
                    Card(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextFormField(
                          onChanged: (value) => groupName = value,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          controller: groupNameController,
                          decoration: InputDecoration(
                            labelText: "Name",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    // Email
                    SizedBox(height: 10.0),
                    Text("Add a new group member"),
                    SizedBox(height: 10.0),
                    Card(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          controller: emailControler,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Column(
                      children: membersToAddMap.values.toList(),
                    ),
                    SizedBox(height: 10.0),
                    Text("Group Members"),
                    SizedBox(height: 10.0),
                    Column(
                      children: groupMembers.values.toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
