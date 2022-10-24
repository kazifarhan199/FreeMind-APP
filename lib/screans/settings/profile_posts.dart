import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/posts.dart';
import '../../models/users.dart';
import '../../routing.dart';
import '../utils/errorBox.dart';
import '../utils/loading.dart';
import '../utils/nothing.dart';

class ProfilePost extends StatefulWidget {
  int uid;
  ProfilePost({required this.uid, Key? key}) : super(key: key);

  @override
  State<ProfilePost> createState() => _ProfilePostState();
}

class _ProfilePostState extends State<ProfilePost> {
  ScrollController _scrollController = ScrollController();
  PostModel postControler = PostModel.fromJson({});
  User loggedInUser = Hive.box('userBox').getAt(0) as User;
  User user = User.fromJson({});
  bool loading = false, moreAvailable = true;
  List<PostModel> posts = [];
  int nextPage = 1;

  profileEditMethod() {
    Routing.profileEditPage(context);
  }

  postDetailMethod(PostModel post) async {
    await Routing.PostPage(context, post, defaultCollapsed: false);
    setState(() {
      post;
    });
  }

  Future<void> getPostsMethod() async {
    nextPage += 1;
    try {
      List<PostModel> localPost = await postControler.getProfilePostList(
          page: nextPage - 1, uid: widget.uid);
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

  Future<void> getUserMethod() async {
    try {
      User u = await User.getUserProfile(uid: widget.uid);
      setState(() {
        user = u;
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
    await getUserMethod();
    await getPostsMethod();
    if (mounted) setState(() => loading = false);
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

  @override
  void initState() {
    super.initState();
    getInitialPosts();
    getUserMethod();

    // Check the user position to load more posts in profile
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
        title: Text(user.userName),
      ),
      body: RefreshIndicator(
        onRefresh: refreshMethod,
        child: Loading(
          loading: loading,
          child: posts.length == 0
              ? Nothing(text: "No posts")
              : ListView.builder(
                  itemCount: (posts.length / 2).ceil() + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // return Container();
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: user.id == loggedInUser.id
                                  ? profileEditMethod
                                  : () {},
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(user.imageUrl),
                                radius: 60.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  // child: Center(child: Text(user.userName, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20.0), )),),
                                  // Padding(padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                    user.bio,
                                  )),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    } else if (index == 1) {
                      return Container();
                    } else {
                      return Row(
                        children: [
                          InkWell(
                            onTap: (() =>
                                postDetailMethod(posts[(index - 1) * 2 - 2])),
                            child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    // Text(
                                    //     posts[(index - 1) * 2 - 2].id.toString()),
                                    Image.network(
                                      posts[(index - 1) * 2 - 2].imageUrl,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                    ),
                                  ],
                                )),
                          ),
                          (index - 1) * 2 - 1 < posts.length
                              ? InkWell(
                                  onTap: (() => postDetailMethod(
                                      posts[(index - 1) * 2 - 1])),
                                  child: Column(
                                    children: [
                                      // Text(posts[(index - 1) * 2 - 1]
                                      //     .id
                                      //     .toString()),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Image.network(
                                            posts[(index - 1) * 2 - 1].imageUrl,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                          )),
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      );
                    }
                  },
                ),
        ),
      ),
    );
  }
}
