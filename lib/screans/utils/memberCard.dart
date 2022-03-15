// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:social/models/groups.dart';

class 
MemeberCard extends StatefulWidget {
  membersModel member;
  Function removeMemberMethod;
  MemeberCard({required this.member, required this.removeMemberMethod, Key? key}) : super(key: key);

  @override
  State<MemeberCard> createState() => _MemeberCardState();
}

class _MemeberCardState extends State<MemeberCard> {

  showOptions() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Memeber'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: const Text('Remove'),
            onPressed: () {
              Navigator.pop(context);
              widget.removeMemberMethod(widget.member.email);
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
    return InkWell(
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
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.member.userImageUrl),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.member.userName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                IconButton(
                onPressed: showOptions, icon: Icon(CupertinoIcons.ellipsis))
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
