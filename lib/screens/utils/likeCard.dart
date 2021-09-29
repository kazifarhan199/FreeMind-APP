import 'package:flutter/material.dart';
import 'package:social/models/posts.dart';

class LikeCard extends StatelessWidget {
  LikesModel like;
  LikeCard(this.like);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(like.userImageURL),
              ),
              SizedBox(width: 8.0),
              Text(like.userName),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.1,
          height: 0.1,
        )
      ],
    );
  }
}
