import 'package:social/screans/Auth/login.dart';
import 'package:social/screans/home/home.dart';
import 'package:social/screans/settings/channel.dart';
import 'package:social/screans/settings/groups_list.dart';
import 'package:social/screans/settings/crises.dart';
import 'package:social/screans/settings/health_services.dart';
import 'package:social/screans/settings/profile_posts.dart';
import 'package:social/screans/utils/loadPost.dart';
import 'package:social/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:social/models/posts.dart';
import 'package:social/screans/post/post.dart';
import 'package:social/screans/home/settings.dart';
import 'package:social/screans/Auth/register.dart';
import 'package:social/screans/settings/survey.dart';
import 'package:social/screans/settings/profile.dart';
import 'package:social/screans/settings/groups.dart';
import 'package:social/screans/home/createPost.dart';
import 'package:social/screans/settings/password.dart';
import 'package:social/screans/Auth/resetPassword.dart';
import 'package:social/screans/home/notifications.dart';

class Routing {
  static wrapperPage(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Wrapper()),
    );
  }

  static homePage(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  static loginPage(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  static registerPage(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Register()),
    );
  }

  static resetPasswordPage(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResetPassword()),
    );
  }

  static settingsPage(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Settings()),
    );
  }

  static createPostPage(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePost()),
    );
  }

  static notificationsPage(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Notifications()),
    );
  }

  static profilePage(context, {required int uid}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfilePost(
                uid: uid,
              )),
    );
  }

  static profileEditPage(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Profile()),
    );
  }

  static passwordPage(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Password()),
    );
  }

  static groupsPage(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupsList()),
    );
  }

  static groupsDetailPage(context, {required int gid, bool doublePop = true}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Group(gid: gid, doublePop: doublePop)),
    );
  }

  static ChannelsPage(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Channel()),
    );
  }

  static crisesPage(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Crises()),
    );
  }

  static healthServicesPage(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HealthServices()),
    );
  }

  static PostPage(context, PostModel post,
      {bool defaultCollapsed = true}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Post(
                post: post,
                defaultCollapsed: defaultCollapsed,
              )),
    );
  }

  static PostPageReplacement(context, PostModel post) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Post(post: post, defaultCollapsed: false)),
    );
  }

  static SurveyPage(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Survey()),
    );
  }

  static SurveyPagePopup(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Survey()),
    );
  }

  static LoadPostPage(context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadPost(id: id)),
    );
  }
}
