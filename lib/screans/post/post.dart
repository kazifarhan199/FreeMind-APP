// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social/models/posts.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/nothing.dart';
import 'package:social/screans/utils/postCard.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/likeCard.dart';
import 'package:social/screans/utils/textInput.dart';
import 'package:social/screans/utils/commentCard.dart';

class Post extends StatefulWidget {
  PostModel post;
  bool defaultCollapsed;
  Post({required this.post, this.defaultCollapsed = true, Key? key})
      : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> with TickerProviderStateMixin {
  final textController = TextEditingController();
  late TabController _tabController;
  bool loadingcomments = false, loadinglikes = false, loading = false;
  List<CommentModel> comments = [];
  List<LikeModel> likes = [];

  deletePostMethod(PostModel localPost) {
    try {
      localPost.deletePost();
      Navigator.pop(context);
    } on Exception catch (e) {
      errorBox(
          context: context,
          errorTitle: "Error",
          error: e.toString().substring(11));
    }
  }

  Future<void> addCommentMethod() async {
    if (mounted) setState(() => loadingcomments = true);
    try {
      await widget.post.addComment(textController.text);
      textController.text = '';
      FocusManager.instance.primaryFocus?.unfocus();
      if (mounted) setState(() => comments = []);
      if (mounted) setState(() => comments = widget.post.commentsList);
      setState(() => widget.post);
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }
    if (mounted) setState(() => loadingcomments = false);
  }

  Future<void> getCommentMethod() async {
    if (mounted) setState(() => loadingcomments = true);
    try {
      comments = await widget.post.getCommentList();
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }
    if (mounted) setState(() => loadingcomments = false);
  }

  Future<void> deleteComment(int id) async {
    if (mounted) setState(() => loadingcomments = true);
    try {
      await widget.post.removeComment(id);
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }

    if (mounted) setState(() => comments = []);
    if (mounted) setState(() => comments = widget.post.commentsList);
    if (mounted) setState(() => loadingcomments = false);
  }

  Future<void> getLikesMethod() async {
    if (mounted) setState(() => loadinglikes = true);
    try {
      likes = await widget.post.getLikeList();
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }
    if (mounted) setState(() => loadinglikes = false);
  }

  Future<void> commentsRefreshMethod() async {
    if (mounted) setState(() => comments = []);
    await getCommentMethod();
  }

  Future<void> likesRefreshMethod() async {
    if (mounted) setState(() => likes = []);
    await getLikesMethod();
  }

  Future<void> refreshMethod() async {
    if (mounted) setState(() => comments = []);
    if (mounted) setState(() => likes = []);

    await getLikesMethod();
    await getCommentMethod();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getCommentMethod();
    getLikesMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      loading: loading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Post"),
        ),
        body: Column(
          children: [
            PostCard(
              deletePostMethod: deletePostMethod,
              post: widget.post,
              refreshMethod: refreshMethod,
              defaultCollapsed: widget.defaultCollapsed,
            ),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                    icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.comment,
                      color: Colors.black,
                    ),
                    Text(
                      ' ' + widget.post.comments.toString() + ' ',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                )),
                Tab(
                    icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite, color: Colors.red),
                    Text(
                      ' ' + widget.post.likes.toString() + ' ',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                )),
              ],
            ),
            Expanded(
                child: TabBarView(controller: _tabController, children: [
              RefreshIndicator(
                onRefresh: commentsRefreshMethod,
                child: Loading(
                  loading: loadingcomments,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: comments.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= comments.length)
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: TextInput(
                                      labelText: "Comment",
                                      controller: textController),
                                ),
                              ),
                              IconButton(
                                  onPressed: addCommentMethod,
                                  icon: Icon(Icons.send))
                            ],
                          ),
                        );
                      ;
                      return CommentCard(
                          comment: comments[index],
                          post: widget.post,
                          deleteComment: deleteComment);
                    },
                  ),
                ),
              ),
              RefreshIndicator(
                onRefresh: likesRefreshMethod,
                child: Loading(
                  loading: loadinglikes,
                  child: likes.length == 0
                      ? Nothing(text: "No likes")
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemCount: likes.length + 1,
                          itemBuilder: (context, index) {
                            if (index == likes.length)
                              return SizedBox(height: 70.0);
                            return LikeCard(
                              like: likes[index],
                            );
                          },
                        ),
                ),
              )
            ])),
          ],
        ),
      ),
    );
  }
}
