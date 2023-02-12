// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:social/models/posts.dart';
import 'package:social/models/notifications.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/errorBox.dart';

class NotificationsCard extends StatefulWidget {
  NotificationsModel notification;
  NotificationsCard({required this.notification, Key? key}) : super(key: key);

  @override
  State<NotificationsCard> createState() => _NotificationsCardState();
}

class _NotificationsCardState extends State<NotificationsCard> {
  bool loading = false;

  goToPostMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      if (widget.notification.type == "post" ||
          widget.notification.type == "comment" ||
          widget.notification.type == "like") {
        PostModel post = await PostModel.fromJson({})
            .getPost(id: widget.notification.send_object);
        Routing.PostPage(context, post);
      } else if (widget.notification.type == "reminder") {
        Routing.createPostPage(context);
      } else if (widget.notification.type == "survey") {
        Routing.SurveyPagePopup(context);
      }
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: () {},
      onTap: goToPostMethod,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.notification.imageURL),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.notification.title,
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
