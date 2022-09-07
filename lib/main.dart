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

awsomeNotificationListner() {
  try {
    AwesomeNotifications().actionStream.listen((receivedNotification) async {
      print("received from the listener");
      Routing.LoadPostPage(navigatorKey.currentContext,
          int.parse(receivedNotification.payload!['post']!));
    });
  } catch (e) {}
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox('userBox');

  await Firebase.initializeApp();
  await getPermissions();
  FirebaseMessaging.onMessage.listen(firebaseMessagingForegroundHandler);
  FirebaseMessaging.onMessageOpenedApp
      .listen(firebaseMessagingForegroundHandler);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  var iosToken = await FirebaseMessaging.instance.getAPNSToken();
  print(token);
  print(iosToken);

  await awsomeNotificationInit();
  await awsomeNotificationPermissions();

  HttpOverrides.global = new MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    awsomeNotificationListner();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      home: MainWrapper(),
    );
  }
}

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key}) : super(key: key);

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  @override
  Widget build(BuildContext context) {
    return Wrapper();
  }
}
