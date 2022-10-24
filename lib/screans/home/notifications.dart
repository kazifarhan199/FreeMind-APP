// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:social/models/notifications.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/nothing.dart';
import 'package:social/screans/utils/notificationsCard.dart';

class Notifications extends StatefulWidget {
  Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  NotificationsModel notificationsControler = NotificationsModel.fromJson({});
  ScrollController _scrollController = ScrollController();
  List<NotificationsModel> notifications = [];
  bool loading = false, moreAvailable = true;
  int nextPage = 1;

  Future<void> getNotifications() async {
    nextPage += 1;
    if (mounted) setState(() => loading = true);
    try {
      List<NotificationsModel> localNotifications =
          await notificationsControler.getNotificationsList(page: nextPage - 1);
      setState(() {
        if (nextPage == 1)
          notifications = localNotifications;
        else
          notifications += localNotifications;
        moreAvailable = false; //Edit if using multimple pages
      });
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }

    if (mounted) setState(() => loading = false);
  }

  Future<void> refreshMethod() async {
    if (mounted) setState(() => notifications = []);
    nextPage = 1;
    moreAvailable = true;
    getNotifications();
  }

  @override
  void initState() {
    super.initState();
    getNotifications();

    // Check the user position to load more notifications
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (moreAvailable) getNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Notifications"),
      ),
      body: RefreshIndicator(
        onRefresh: refreshMethod,
        child: Loading(
          loading: loading,
          child: notifications.length == 0
              ? Nothing(text: "No Notifications")
              : ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: notifications.length + 1,
                  itemBuilder: (context, index) {
                    if (index == notifications.length) {
                      if (moreAvailable)
                        return SizedBox(
                            height: 150,
                            width: 100,
                            child: Loading(loading: true, child: Container()));
                      else
                        return SizedBox(height: 100, width: 100);
                    }
                    return NotificationsCard(
                        notification: notifications[index]);
                  },
                ),
        ),
      ),
    );
  }
}
