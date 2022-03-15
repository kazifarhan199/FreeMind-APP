import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:social/screans/utils/notificationUtils.dart';


final FirebaseMessaging messaging = FirebaseMessaging.instance;

Future getPermissions() async {
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

Future firebaseMessagingForegroundHandler(RemoteMessage message) async {
  sendAwsomeNotification(message.data);
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  sendAwsomeNotification(message.data);
}
