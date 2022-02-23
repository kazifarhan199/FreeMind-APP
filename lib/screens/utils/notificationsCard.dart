import 'package:flutter/material.dart';
import 'package:social/models/notifiactions.dart';

class NotificationsCard extends StatefulWidget {
  NotificationsModel notification;
  NotificationsCard(this.notification);

  @override
  _NotificationsCardState createState() => _NotificationsCardState();
}

class _NotificationsCardState extends State<NotificationsCard> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundImage: NetworkImage(widget.notification.imageURL),
                  ),
              SizedBox(width: 8.0),
              Expanded(child: Text(widget.notification.text)),
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
