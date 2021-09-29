import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:social/models/postList.dart';
import 'package:social/models/posts.dart';
import 'package:social/models/users.dart';
import 'package:social/screens/utils/alert.dart';
import 'package:social/screens/utils/loading.dart';
import 'package:social/screens/utils/postCard.dart';

class Feeds extends StatefulWidget {
  const Feeds({Key? key}) : super(key: key);

  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  PostListModel posts = PostListModel();
  PostModel post = PostModel({});
  ScrollController _scrollController = ScrollController();

  raiseError() {
    if (post.hasError) {
      showAlertDialog(context: context, title: Text(post.error));
    } else {
      showAlertDialog(context: context, title: Text("Some error occured"));
    }
  }

  Future getPosts() async {
    List<PostModel> newPostList = await posts.getPostList(newPage: 1);
    if (post.hasError) {
      raiseError();
    } else {
      Map<int, PostModel> new_posts = {};
      for (var p in newPostList) {
        new_posts[p.id] = p;
      }
      if (mounted) {
        posts.postMap = {};
        posts.addAll(new_posts);
        setState(() {});
      }
    }
  }

  Future getMorePosts() async {
    List<PostModel> newPostList = await posts.getPostList();

    if (post.hasError) {
      raiseError();
    } else {
      Map<int, PostModel> new_posts = {};
      for (var p in newPostList) {
        new_posts[p.id] = p;
      }
      setState(() {
        posts.addAll(new_posts);
      });
    }
  }

  Future<bool> removePost(int id) async {
    bool success = await posts.deletePost(id, silent: true);
    setState(() {});
    return success;
  }

  createPostPageMethod() {
    DefaultTabController.of(context)!.animateTo(2);
  }

  settingsPageMethod() {
    DefaultTabController.of(context)!.animateTo(0);
  }

  notificationsPageMethod() {
    Navigator.of(context).pushNamed("/notifications");
  }

  Future reloadPageMethod() async {
    await getPosts();
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void initState() {
    getPosts();
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMorePosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: Tooltip(
          message: "Settings",
          child: IconButton(
            icon: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                  Provider.of<User>(context).imageURL),
            ),
            onPressed: settingsPageMethod,
          ),
        ),
        title: Text("Phamily Health"),
        // centerTitle: true,
        actions: [
          Tooltip(
            message: "Notifications",
            child: IconButton(
              icon: Icon(Icons.notifications), //notificationCountWidget,
              onPressed: notificationsPageMethod,
            ),
          ),
          Tooltip(
            message: "Create a post",
            child: IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                size: 30.0,
              ),
              onPressed: createPostPageMethod,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: reloadPageMethod,
        child: ChangeNotifierProvider(
          create: (context) => posts,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            controller: _scrollController,
            itemCount: posts.length + 1,
            itemBuilder: (context, index) {
              if (index == posts.length && posts.next != '') {
                return SizedBox(
                  child: Container(
                    child: Center(
                      child: SpinKitChasingDots(
                        color: Colors.blue,
                        size: 50.0,
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                );
              }
              if (index == posts.length && posts.next == '') {
                return Container();
              }
              return PostCard(posts.values[index]!.id, removePost);
            },
          ),
        ),
      ),
    ));
  }
}
