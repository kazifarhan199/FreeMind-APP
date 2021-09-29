import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social/models/postList.dart';
import 'package:social/models/posts.dart';
import 'package:social/screens/utils/alert.dart';
import 'package:social/screens/utils/commentCard.dart';
import 'package:social/screens/utils/loading.dart';

class Comment extends StatefulWidget {
  int id;
  PostListModel postList;
  Comment(this.postList, this.id, {Key? key}) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<CommentsModel> comments = [];
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

  getComments() async {
    if (mounted) setState(() => loading = true);

    List<CommentsModel> new_comments =
        await widget.postList.postMap[widget.id]!.commentsList();

    if (widget.postList.postMap[widget.id]!.hasError) {
      raiseError();
    } else {
      if (mounted)
        setState(() {
          comments = new_comments;
        });
    }
    if (mounted) setState(() => loading = false);
  }

  likePageMethod() {
    FocusScope.of(context).unfocus();
    DefaultTabController.of(context)!.animateTo(1);
  }

  Future refreshPage() async {
    await getComments();
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void initState() {
    getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Tooltip(
            message: "Comments",
            child: IconButton(
              icon: Icon(Icons.favorite),
              onPressed: likePageMethod,
            ),
          )
        ],
        title: Text("Comments"),
        // centerTitle: true,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: refreshPage,
            child: loading
                ? Loading()
                : ListView.builder(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: comments.length + 1,
                    itemBuilder: (context, index) {
                      if (index == comments.length)
                        return SizedBox(height: 70.0);
                      return CommentCard(comments[index]);
                    },
                  ),
          ),
          CommentInput(widget.postList, widget.id, refreshPage),
        ],
      ),
    );
  }
}

class CommentInput extends StatefulWidget {
  int id;
  PostListModel postList;
  Function refreshPage = () {};
  CommentInput(this.postList, this.id, this.refreshPage, {Key? key})
      : super(key: key);

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  String text = '';
  final textControler = TextEditingController();

  addCommentMethod() async {
    await widget.postList.addComment(widget.id, text);
    textControler.text = "";
    text = '';
    await widget.refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     CircleAvatar(
            //       child: InkWell(
            //         onTap: () {},
            //       ),
            //       radius: 25.0,
            //       // backgroundImage: NetworkImage("widget.post.image_url"),
            //     ),
            //   ],
            // ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7.0),
                    child: TextFormField(
                      onChanged: (value) => text = value,
                      keyboardType: TextInputType.multiline,
                      maxLength: null,
                      maxLines: null,
                      controller: textControler,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      decoration: InputDecoration(
                        labelText: "Leave a comment",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: addCommentMethod,
                  icon: Icon(
                    Icons.send,
                    // color: Colors.black,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
