// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

awsomeNotificationInit() async {
  await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/icon',
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            importance: NotificationImportance.Max,
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ]);
}

awsomeNotificationPermissions() async {
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
    if (!isAllowed) {
      // Insert here your friendly dialog box before call the request method
      // This is very important to not harm the user experience
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
}

sendAwsomeNotification(Map data) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: int.parse(data["notification_id"]),
      locked: false,
      channelKey: 'basic_channel',
      title: data['title'],
      body: data['body'],
      payload: {
        "object_id": data["object_id"] ?? 0,
        "send_object": data["send_object"] ?? "",
        "type": data["type"] ?? ""
      },
      displayOnForeground: true,
      displayOnBackground: true,
      wakeUpScreen: true,
    ),
  );
}

testingAwsomeNotification() {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: 12,
        locked: false,
        channelKey: 'basic_channel',
        title: "Test Notification",
        body: "This is body of the notification",
        displayOnForeground: true,
        displayOnBackground: true),
  );
}
