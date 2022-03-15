// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:social/models/posts.dart';

class LikeCard extends StatefulWidget {
  LikeModel like;
  LikeCard({required this.like, Key? key}) : super(key: key);

  @override
  State<LikeCard> createState() => _LikeCardState();
}

class _LikeCardState extends State<LikeCard> {


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
                  backgroundImage: NetworkImage(
                      widget.like.userImageUrl),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        widget.like.userName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
