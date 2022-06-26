// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:social/models/groups.dart';
import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/errorBox.dart';

class GroupsCard extends StatefulWidget {
  GroupModel group;
  GroupsCard({required this.group, Key? key}) : super(key: key);

  @override
  State<GroupsCard> createState() => _GroupsCardState();
}

class _GroupsCardState extends State<GroupsCard> {
  bool loading=false;

  groupsDetailPageMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      Routing.groupsDetailPage(context, gid: widget.group.id);
    } on Exception catch( e){
      if (mounted) errorBox(context:context, error:e.toString().substring(11), errorTitle: 'Error'); 
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: () {},
      onTap: groupsDetailPageMethod,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.group.imageUrl),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.group.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      loading ? LoafingInternal() : Container(),
                    ],
                  ),
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
