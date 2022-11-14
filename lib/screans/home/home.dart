// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:social/models/posts.dart';
import 'package:social/models/users.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/nothing.dart';
import 'package:social/screans/utils/postCard.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/vars.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _scrollController = ScrollController();
  PostModel postControler = PostModel.fromJson({});
  User user = Hive.box('userBox').getAt(0) as User;
  bool loading = false, moreAvailable = true;
  List<PostModel> posts = [];
  int nextPage = 1;

  createPostMethod() {
    Routing.createPostPage(context);
  }

  notificationsMethod() {
    Routing.notificationsPage(context);
  }

  profileMethod() {
    Navigator.pop(context);
    Routing.profilePage(context, uid: user.id);
  }

  profileEditMethod() {
    Navigator.pop(context);
    Routing.profileEditPage(context);
  }

  passwordMethod() {
    Navigator.pop(context);
    Routing.passwordPage(context);
  }

  groupMethod() {
    Navigator.pop(context);
    Routing.groupsPage(context);
  }

  surveyMethod() {
    Navigator.pop(context);
    Routing.SurveyPage(context);
  }

  channelsMethod() {
    Navigator.pop(context);
    Routing.ChannelsPage(context);
  }

  showCrisesMethod() {
    Navigator.pop(context);
    Routing.crisesPage(context);
  }

  showHealthServicesMethod() {
    Navigator.pop(context);
    Routing.healthServicesPage(context);
  }

  Future<void> logoutMethod() async {
    Navigator.pop(context);
    if (mounted) setState(() => loading = true);
    try {
      await User.logout();
      Routing.wrapperPage(context);
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> getPostsMethod() async {
    nextPage += 1;
    try {
      List<PostModel> localPost =
          await postControler.getPostList(page: nextPage - 1);
      moreAvailable = postControler.moreAvailable;
      if (mounted)
        setState(() {
          if (nextPage == 1)
            posts = localPost;
          else
            posts += localPost;
        });
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }
  }

  Future<void> deletePostMethod(PostModel localPost) async {
    try {
      await localPost.deletePost();
      setState(() {
        print(posts);
        posts.removeWhere((element) => element.id == localPost.id);
      });
    } on Exception catch (e) {
      errorBox(
          context: context,
          errorTitle: "Error",
          error: e.toString().substring(11));
    }
  }

  Future<void> getInitialPosts() async {
    if (mounted) setState(() => loading = true);
    await getPostsMethod();
    if (mounted) setState(() => loading = false);
  }

  Future<void> refreshMethod() async {
    if (mounted) setState(() => loading = true);
    if (mounted) setState(() => posts = []);
    nextPage = 1;
    moreAvailable = true;
    await getPostsMethod();
    if (mounted) setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    getInitialPosts();

    // Check the user position to load more posts
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (moreAvailable) getPostsMethod();
      }
    });
  }

  showLogoutAlertMethod() {
    Navigator.pop(context);
    Platform.isAndroid
        ? showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Logout'),
              content: Text(InfoStrings.logout_info),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('Yes'),
                  isDestructiveAction: true,
                  onPressed: logoutMethod,
                )
              ],
            ),
          )
        : showCupertinoDialog<void>(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Logout'),
              content: Text(InfoStrings.logout_info),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('Yes'),
                  isDestructiveAction: true,
                  onPressed: logoutMethod,
                )
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          // padding: EdgeInsets.zero,
          children: <Widget>[
            InkWell(
              onTap: profileMethod,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Stack(children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.imageUrl),
                            radius: 35.0,
                          ),
                          Row(
                            children: [
                              SizedBox(width: 45),
                              CircleAvatar(
                                child: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: profileEditMethod,
                                  iconSize: 17,
                                  color: Colors.white,
                                ),
                                radius: 17,
                              ),
                            ],
                          ),
                        ]),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          user.userName
                              .substring(0, min(10, user.userName.length)),
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: TextStyle(color: Colors.white, fontSize: 22.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.group_outlined),
              title: Text('Manage Group'),
              onTap: groupMethod,
            ),
            ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('Change Password'),
              onTap: passwordMethod,
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Channels'),
              onTap: channelsMethod,
            ),
            ListTile(
              leading: Icon(Icons.health_and_safety),
              title: Text('UMD Health Services'),
              onTap: showHealthServicesMethod,
            ),
            ListTile(
              leading: Icon(Icons.emergency),
              title: Text('Crises'),
              onTap: showCrisesMethod,
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: showLogoutAlertMethod,
            ),
            Expanded(child: Container()),
            Opacity(
              opacity: 0.5,
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text(app_version),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(centerTitle: true, title: Text("FreeMind"), actions: [
        IconButton(
            onPressed: notificationsMethod, icon: Icon(Icons.notifications)),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: createPostMethod,
        child: Icon(Icons.add_circle_outline),
      ),
      body: Loading(
        loading: loading,
        child: RefreshIndicator(
          onRefresh: refreshMethod,
          child: posts.length == 0
              ? Nothing(text: "No posts")
              : ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: posts.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= posts.length) if (moreAvailable)
                      return SizedBox(
                          height: 150,
                          width: 100,
                          child: Loading(loading: true, child: Container()));
                    else
                      return SizedBox(height: 100, width: 100);
                    else
                      return PostCard(
                        on_home: true,
                        post: posts[index],
                        deletePostMethod: deletePostMethod,
                      );
                  },
                ),
        ),
      ),
    );
  }
}
