// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:social/models/posts.dart';
import 'package:social/models/users.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/textInput.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentCard extends StatefulWidget {
  CommentModel comment;
  Function deleteComment;
  CommentCard({required this.comment, required this.deleteComment, Key? key})
      : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  User user = Hive.box('userBox').getAt(0) as User;
  FeedbackModel feeback = FeedbackModel.fromJson({});

  sendFeedbackMethod() async{
    try{
      await widget.comment.sendfeedback(feeback:feeback);
      setState(() {});
      Navigator.of(context).pop();
    }catch(e){
      errorBox(context: context, errorTitle: "Error", error: e.toString().substring(11));
    }
  }
  void _launchURL(String url) async {
    try{
      if (!await launch(url)) throw Exception('Could not launch $url');
    }catch(e){
      errorBox(context: context, errorTitle: "Error", error: e.toString().substring(11));
    }
  }

  showOptions() {
        Platform.isAndroid 
    ? showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        height:130,
        child: (
          Column(children:  <Widget>[
          widget.comment.userName == user.userName
              ? Expanded(
                child: CupertinoActionSheetAction(
                    isDestructiveAction: true,
                    child: const Text('Delete'),
                    onPressed: () {
                      widget.deleteComment(widget.comment.id);
                      Navigator.pop(context);
                    },
                  ),
              )
              : Expanded(
                child: CupertinoActionSheetAction(
                    child: const Text('Go back'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
              ),
            Divider(),
            Expanded(
              child: CupertinoDialogAction(
                child: const Text('Cancle'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        )),
      )
    )
    :showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Comment'),
        actions: <CupertinoActionSheetAction>[
          widget.comment.userName == user.userName
              ? CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  child: const Text('Delete'),
                  onPressed: () {
                    widget.deleteComment(widget.comment.id);
                    Navigator.pop(context);
                  },
                )
              : CupertinoActionSheetAction(
                  child: const Text('Go back'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
          CupertinoActionSheetAction(
            child: const Text('Cancle'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.comment.userImageUrl),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.comment.userName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      widget.comment.needFeedback
                          ? ElevatedButton(
                              onPressed: _showCommentFeedback,
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 1.0, vertical: 1.0),
                                child: Text("Give feedback"),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                IconButton(
                    onPressed: showOptions, icon: Icon(CupertinoIcons.ellipsis))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(widget.comment.text),
          ),
          widget.comment.hasLink?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextButton(child: Text("Read more"), onPressed: () => _launchURL(widget.comment.link),),
          ):Container(),
          Divider()
        ],
      ),
    );
  }

  Future<void> _showCommentFeedback() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              // Icon(Icons.feedback),
              SizedBox(
                  // width: 10.0,
                  ),
              Text("FeedBack"),
              SizedBox(
                width: 60,
              )
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Tell us what do you think about the recommendation'),
                SizedBox(height: 20),
                TextInput(
                    initialText: feeback.text,
                    labelText: '',
                    maxlength: 200,
                    keyboardtype: TextInputType.multiline,
                    maxlines: null,
                    onChanged: (val) => feeback.text=val),
                SizedBox(height: 20),
                RatingBar(
                  initialRating: feeback.rating.toDouble(),
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                    full: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ), //_image('assets/heart.png'),
                    half:
                        Icon(Icons.favorite), //_image('assets/heart_half.png'),
                    empty: Icon(Icons
                        .favorite_border), //_image('assets/heart_border.png'),
                  ),
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  onRatingUpdate: (r) {
                    feeback.rating = r.toInt();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: sendFeedbackMethod,
            ),
          ],
        );
      },
    );
  }
}
