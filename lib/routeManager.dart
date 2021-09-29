import 'package:flutter/material.dart';
import 'package:social/models/postList.dart';
import 'package:social/models/posts.dart';
import 'package:social/screens/Auth/login.dart';
import 'package:social/screens/Auth/register.dart';
import 'package:social/screens/Auth/reset_password.dart';
import 'package:social/screens/home/Notifications.dart';
import 'package:social/screens/post/postDetail.dart';
import 'package:social/screens/settings/editGroup.dart';
import 'package:social/screens/settings/editPassword.dart';
import 'package:social/screens/settings/editUser.dart';
import 'package:social/screens/wrapper.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => Wrapper());

    case '/login':
      return MaterialPageRoute(builder: (context) => Login());
    case '/register':
      return MaterialPageRoute(builder: (context) => Register());
    case '/reset_password':
      return MaterialPageRoute(builder: (context) => PasswordReset());

    case '/post_detail':
      return MaterialPageRoute(
          builder: (context) => PostDetail(
              (settings.arguments as List)[0] as PostListModel,
              (settings.arguments as List)[1] as int));

    case '/edit_password':
      return MaterialPageRoute(builder: (context) => EditPassword());

    case '/edit_group':
      return MaterialPageRoute(builder: (context) => EditGroup());

    case '/edit_profile':
      return MaterialPageRoute(builder: (context) => EditProfile());

    case '/notifications':
      return MaterialPageRoute(builder: (context) => Notifications());

    default:
      return MaterialPageRoute(builder: (context) => Wrapper());
  }
}
