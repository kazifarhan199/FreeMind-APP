import 'package:flutter/material.dart';
import 'package:social/models/member.dart';

class GroupMemberCard extends StatefulWidget {
  Member member;
  String email;
  Function removeMember;
  GroupMemberCard(this.member, this.email, this.removeMember, {Key? key})
      : super(key: key);

  @override
  _GroupMemberCardState createState() => _GroupMemberCardState();
}

class _GroupMemberCardState extends State<GroupMemberCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Center(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.member.userImageURL),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child:
                      Text(widget.member.userName + '\n' + widget.member.email),
                ),
                IconButton(
                    onPressed: () => {widget.removeMember(widget.email)},
                    icon: Text("X"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
