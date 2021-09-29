import 'package:flutter/material.dart';
import 'package:social/models/notifiactions.dart';

class NotificationsCard extends StatefulWidget {
  const NotificationsCard({Key? key}) : super(key: key);

  @override
  _NotificationsCardState createState() => _NotificationsCardState();
}

class _NotificationsCardState extends State<NotificationsCard> {
  NotificationsModel notification = NotificationsModel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                  // backgroundImage: NetworkImage(notification.image),
                  ),
              SizedBox(width: 8.0),
              Text(notification.text),
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
