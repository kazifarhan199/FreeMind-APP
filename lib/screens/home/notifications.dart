import 'package:flutter/material.dart';
import 'package:social/models/notifiactions.dart';
import 'package:social/screens/utils/notificationsCard.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<NotificationsModel> notifications = [];

  Future reloadPageMethod() async {
    await Future.delayed(Duration(seconds: 3));
  }

  getNotificationsList() async {
    notifications.addAll([NotificationsModel(), NotificationsModel()]);
  }

  @override
  void initState() {
    getNotificationsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: RefreshIndicator(
        onRefresh: reloadPageMethod,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return NotificationsCard();
          },
        ),
      ),
    );
  }
}
