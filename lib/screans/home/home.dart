// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:hive/hive.dart';
import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:social/models/posts.dart';
import 'package:social/models/users.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/nothing.dart';
import 'package:social/screans/utils/postCard.dart';
import 'package:social/screans/utils/errorBox.dart';

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

  settingsMethod() {
    Routing.settingsPage(context);
  }

  createPostMethod() {
    Routing.createPostPage(context);
  }

  notificationsMethod() {
    Routing.notificationsPage(context);
  }

  getPostsMethod() async {
    nextPage += 1;
    if (mounted) setState(() => loading = true);
    try {
      List<PostModel> localPost =
          await postControler.getPostList(page: nextPage - 1);
      moreAvailable = postControler.moreAvailable;
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

    if (mounted) setState(() => loading = false);
  }

  Future<void> refreshMethod() async {
    if (mounted) setState(() => posts = []);
    nextPage = 1;
    moreAvailable = true;
    getPostsMethod();
  }

  Future deletePostMethod(PostModel localPost) async {
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

  @override
  void initState() {
    super.initState();
    getPostsMethod();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (moreAvailable) getPostsMethod();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: CircleAvatar(backgroundImage: NetworkImage(user.imageUrl)),
            onPressed: settingsMethod,
          ),
          title: Text("Social"),
          // flexibleSpace: Image(
          //   image: AssetImage('assets/background.png'),
          //   fit: BoxFit.cover,
          // ),
          // backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: notificationsMethod,
                icon: Icon(Icons.notifications)),
            IconButton(
                onPressed: createPostMethod,
                icon: Icon(Icons.add_circle_outline)),
          ]),
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
