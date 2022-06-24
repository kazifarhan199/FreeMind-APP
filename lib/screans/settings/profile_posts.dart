// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:social/models/posts.dart';
import 'package:social/models/users.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/nothing.dart';
import 'package:social/screans/utils/postCard.dart';
import 'package:social/screans/utils/errorBox.dart';

class ProfilePost extends StatefulWidget {
  const ProfilePost({Key? key}) : super(key: key);

  @override
  State<ProfilePost> createState() => _ProfilePostState();
}

class _ProfilePostState extends State<ProfilePost> {
  ScrollController _scrollController = ScrollController();
  PostModel postControler = PostModel.fromJson({});
  User user = Hive.box('userBox').getAt(0) as User;
  bool loading = false, moreAvailable = true;
  List<PostModel> posts = [];
  int nextPage = 1;

  profileEditMethod() {
    Routing.profileEditPage(context);
  }

  getPostsMethod() async {
    nextPage += 1;
    try {
      List<PostModel> localPost =
          await postControler.getProfilePostList(page: nextPage - 1);
      moreAvailable = postControler.moreAvailable;
      if(mounted) setState(() {
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

  Future<void> refreshMethod() async {
    if (mounted) setState(() => loading = true);
    if (mounted) setState(() => posts = []);
    nextPage = 1;
    moreAvailable = true;
    await getPostsMethod();
    if (mounted) setState(() => loading = false);
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

  getInitialPosts() async {
    if (mounted) setState(() => loading = true);
    await getPostsMethod();
    if (mounted) setState(() => loading = false);
  }

  postDetailMethod(PostModel post) async {
      await Routing.PostPage(context, post, defaultCollapsed:false);
      setState(() {post;});
  }

  @override
  void initState() {
    super.initState();
    getInitialPosts();

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
          title: Text("Profile"),
          // flexibleSpace: Image(
          //   image: AssetImage('assets/background.png'),
          //   fit: BoxFit.cover,
          // ),
          // backgroundColor: Colors.transparent,
      ),
      body: Loading(
        loading: loading,
        child: RefreshIndicator(
          onRefresh: refreshMethod,
          child: posts.length == 0
          ? Nothing(text: "No posts")
          : Expanded(
            child: GridView.builder(
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2, mainAxisSpacing: 0.0, crossAxisSpacing:15.0),
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
                itemCount: posts.length+2,
                itemBuilder: (context, index) {
                  if (index==0){
                    return Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: InkWell(
                        onTap: profileEditMethod,
                        child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(user.imageUrl),
                        radius: 30.0,
                        ),
                      ),
                    );
                  }
                  else if (index==1){
                    return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(user.userName, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20.0), )),),
                              Padding(padding: const EdgeInsets.all(5.0),
                              child: Expanded(child: Center(child: Text(user.bio,))),),
                            ],
                          );
                  }
                  else{
                    return InkWell(
                      onTap: (() => postDetailMethod(posts[index-2])),
                      child: Image(image: NetworkImage(posts[index-2].imageUrl)),
                    );
                  }
                }
                )
          ),
      ),
    ),);
  }
}
