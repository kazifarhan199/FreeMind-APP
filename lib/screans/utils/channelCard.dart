// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:social/models/groups.dart';
import 'package:social/models/users.dart';
import 'package:social/screans/utils/loading.dart';

class 
ChannelCard extends StatefulWidget {
  GroupModel group;
  ChannelCard({required this.group, Key? key}) : super(key: key);

  @override
  State<ChannelCard> createState() => _ChannelCardState();
}

class _ChannelCardState extends State<ChannelCard> {
  bool _switchValue=true;
  bool loading=false;
  User user = Hive.box('userBox').getAt(0) as User;

  @override
  void initState() {
    super.initState();
    _switchValue = widget.group.isin;
  }

  addUserMethod() async {
    setState(() => loading = true);
    await widget.group.addMember(email: user.email, channel: true, group:widget.group.id);
    setState(() => loading = false);
  }

  removeUserMethod() async {
    setState(() => loading = true);
    await widget.group.removeMember(email: user.email, channel: true, group: widget.group.id);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return loading?SizedBox(height: 60, width:60, child: Center(child: LoafingInternal()),):InkWell(
      onDoubleTap: () {},
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // CircleAvatar(
                //   backgroundImage: NetworkImage(widget.member.userImageUrl),
                // ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.group.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                CupertinoSwitch(
              value: _switchValue,
              onChanged: (value) {
                  if (value){
                    addUserMethod();
                  }
                  else{
                    removeUserMethod();
                  }
                  _switchValue = value;
              },
            ),
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
