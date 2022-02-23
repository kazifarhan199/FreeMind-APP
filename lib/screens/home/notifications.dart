import 'package:flutter/material.dart';
import 'package:social/models/notifiactions.dart';
import 'package:social/screens/utils/alert.dart';
import 'package:social/screens/utils/loading.dart';
import 'package:social/screens/utils/notificationsCard.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<NotificationsModel> notifications = [];
  NotificationsModelList notificationsmodellist = NotificationsModelList();
  bool loading = true;

  raiseError() {
    setState(() {
      loading = true;
    });
    if (notificationsmodellist.hasError) {
      showAlertDialog(context: context, title: Text(notificationsmodellist.error));
    } else {
      showAlertDialog(context: context, title: Text("Some error occured"));
    }
    setState(() {
      loading = false;
    });
  }
  
  Future reloadPageMethod() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    getNotificationsList();
    setState(() {
      loading = false;
    });
  }

  getNotificationsList() async {    
    setState(() {
      loading = true;
    });
    bool success = await notificationsmodellist.getNotifications();
    setState(() {
      notifications = notificationsmodellist.notifications;
    });
    if (success){
      
    }
    else{
      raiseError();
    }
    setState(() {
      loading = false;
    });
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
      body: loading == true ? Loading() :RefreshIndicator(
        onRefresh: reloadPageMethod,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return NotificationsCard(notifications[index]);
          },
        ),
      ),
    );
  }
}
