import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:social/models/users.dart';
import 'package:social/routeManager.dart';
import 'package:social/screens/wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:social/utils/awsomeNotification.dart';
import 'package:social/utils/firebaseUtils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Hive init
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox('userBox');

  // Firebase
  await Firebase.initializeApp();
  await getPermissions();
  FirebaseMessaging.onMessage.listen(firebaseMessagingForegroundHandler);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Not needed in final one, BUT IT IS STILL IN USE FOR INITAILIZATION PURPOSE
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  print("Token is ");
  print(token);
  print('---');

  // awsome Notification
  await awsomeNotificationInit();
  await awsomeNotificationPermissions();
  await awsomeNotificationListner();

  User user = User();
  if (Hive.box('userBox').isNotEmpty) {
    user = Hive.box('userBox').getAt(0) as User;
    print(await user.getDeviceToekn());
  }
  // TO handel self signed crertificate
  HttpOverrides.global = new MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (_) => user),
      ],
      child: MyApp(),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phamily Health',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: generateRoute,
      home: Wrapper(),
    );
  }
}
