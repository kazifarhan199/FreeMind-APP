import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:social/screans/utils/postCard.dart';
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
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: user.id == loggedInUser.id ? profileEditMethod : () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.imageUrl),
                    radius: 60.0,
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 80,
                  child: SingleChildScrollView(
                    child: Text(
                      user.bio,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                )),
            Expanded(
              child: posts.length == 0
                  ? Nothing(text: "No posts")
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                        crossAxisCount: 2,
                      ),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            postDetailMethod(posts[index]);
                          },
                          child: posts[index].isRecommendation
                              ? Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        posts[index].title +
                                            posts[index].title +
                                            posts[index].title,
                                        style: TextStyle(fontSize: 21),
                                      ),
                                    ),
                                  ))
                              : Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          NetworkImage(posts[index].imageUrl),
                                    ),
                                  ),
                                ),
                        );
                      }),
            )
          ]),
        ),
      ),
    );
  }
}
