import 'package:flutter/material.dart';
import 'package:social/models/postList.dart';
import 'package:social/screens/post/comment.dart';
import 'package:social/screens/post/like.dart';

class PostDetail extends StatefulWidget {
  PostListModel postList;
  int id;
  PostDetail(this.postList, this.id);
  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        body: TabBarView(
          children: [
            Comment(widget.postList, widget.id),
            Like(widget.postList, widget.id),
          ],
        ),
      ),
    );
  }
}
