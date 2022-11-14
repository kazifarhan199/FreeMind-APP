import 'dart:io';
import 'package:social/routing.dart';
import 'package:social/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social/models/users.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social/models/firebaseUtils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:social/screans/utils/notificationUtils.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// This function is triggered when the user clicks on a notification
//  it will then look at which page to open and open that page in the app
awsomeNotificationListner() {
  try {
    AwesomeNotifications().actionStream.listen((receivedNotification) async {
      print("received from the listener");
      print(receivedNotification.payload!["survey"]);
      if (receivedNotification.payload!["survey"] == "true") {
        Routing.SurveyPagePopup(navigatorKey.currentContext);
      } else {
        Routing.LoadPostPage(navigatorKey.currentContext,
            int.parse(receivedNotification.payload!['post']!));
      }
    });
  } catch (e) {}
}

// This class allows self signed ssl certificate
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  // Fun ensures that the app is loaded and then continues
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing the data bases (also registering UserAdapter model)
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox('userBox');

  // Initializing firebase also asking for permission and setting up listners
  await Firebase.initializeApp();
  await getPermissions();
  FirebaseMessaging.onMessage.listen(firebaseMessagingForegroundHandler);
  FirebaseMessaging.onMessageOpenedApp
      .listen(firebaseMessagingForegroundHandler);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Getting the firebase token and APNS(Apple push notifications) token and
  // printing it
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  var iosToken = await FirebaseMessaging.instance.getAPNSToken();
  print(token);
  print(iosToken);

  // Initializing notifications and asking for permission
  await awsomeNotificationInit();
  await awsomeNotificationPermissions();

  // Allowing self signed ssl certificates
  HttpOverrides.global = new MyHttpOverrides();

  // Starting the App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Setting app orientation, not alloing app rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Listen for notification when notification is clicked
    awsomeNotificationListner();

    // The main material app
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      home: Wrapper(),
    );
  }
}
