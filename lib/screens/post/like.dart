import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social/models/postList.dart';
import 'package:social/models/posts.dart';
import 'package:social/screens/utils/alert.dart';
import 'package:social/screens/utils/likeCard.dart';
import 'package:social/screens/utils/loading.dart';

class Like extends StatefulWidget {
  int id;
  PostListModel postList;
  Like(this.postList, this.id, {Key? key}) : super(key: key);

  @override
  _LikeState createState() => _LikeState();
}

class _LikeState extends State<Like> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<LikesModel> likes = [];
  bool loading = false;

  raiseError() {
    if (widget.postList.postMap[widget.id]!.hasError) {
      showAlertDialog(
          context: context,
          title: Text(widget.postList.postMap[widget.id]!.error));
    } else {
      showAlertDialog(context: context, title: Text("Some error occured"));
    }
  }

  commentPageMethod() {
    DefaultTabController.of(context)!.animateTo(0);
  }

  getLikes() async {
    if (mounted) setState(() => loading = true);
    List<LikesModel> newLikes =
        await widget.postList.postMap[widget.id]!.likesList();
    if (widget.postList.postMap[widget.id]!.hasError) {
      raiseError();
    } else {
      if (mounted)
        setState(() {
          likes = newLikes;
        });
    }
    if (mounted) setState(() => loading = false);
  }

  Future refreshPage() async {
    await getLikes();
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      getLikes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Tooltip(
              message: "Likes",
              child: IconButton(
                icon: FaIcon(FontAwesomeIcons.comment),
                onPressed: commentPageMethod,
              ),
            )
          ],
          title: Text("Likes"),
          // centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: refreshPage,
          child: loading
              ? Loading()
              : ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  // controller: _scrollController,
                  itemCount: likes.length,
                  itemBuilder: (context, index) {
                    return LikeCard(likes[index]);
                  },
                ),
        ));
  }
}
