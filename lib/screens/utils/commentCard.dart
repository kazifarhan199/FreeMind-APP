import 'package:flutter/material.dart';
import 'package:social/models/posts.dart';

class CommentCard extends StatelessWidget {
  CommentsModel comment;
  CommentCard(this.comment);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(comment.userImageURL),
              ),
              SizedBox(width: 8.0),
              Text(comment.userName),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(comment.text),
        ),
        SizedBox(height: 8.0),
        Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 0.1,
        )
      ],
    );
  }
}
