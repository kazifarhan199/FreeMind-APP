import 'package:flutter/material.dart';
import 'package:social/models/posts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:social/screens/utils/alert.dart';

class CommentCard extends StatefulWidget {
  CommentsModel comment;
  CommentCard(this.comment);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  String text='';
  int rating = 0;
  sendfeedback() async {
    bool success = await widget.comment.sendfeedback(text, rating);
    if (success){
      setState(() {
      widget.comment.need_feadback = false;
      });
    }
    else {
      raiseError();
    }
  }

 raiseError() {
    if (widget.comment.hasError) {
      showAlertDialog(context: context, title: Text(widget.comment.error));
    } else {
      showAlertDialog(context: context, title: Text("Some error occured"));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.comment.userImageURL),
              ),
              SizedBox(width: 8.0),
              Text(widget.comment.userName),
              SizedBox(width: 40,),

              widget.comment.need_feadback ? 
                ElevatedButton(
                  onPressed: _showCommentFeedback,
                  style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 1.0, vertical: 1.0),
                    child: Text("Give feedback"),
                  ),
                ) :
                SizedBox()

            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(widget.comment.text),
        ),
        SizedBox(height: 8.0),
        Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 0.1,
        )
      ],
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
                                  Card(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                                      child: TextFormField(
                                        onChanged: (value) => text = value,
                                        keyboardType: TextInputType.multiline,
                                        // maxLength: 200,
                                        maxLines: null,
                                        initialValue: text,
                                        decoration: InputDecoration(
                                          // labelText: "text",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height:20),

RatingBar(
   initialRating: rating.toDouble(),
   direction: Axis.horizontal,
   allowHalfRating: false,
   itemCount: 10,
   ratingWidget: RatingWidget(
     full: Icon(Icons.favorite, color: Colors.red,), //_image('assets/heart.png'),
     half: Icon(Icons.favorite), //_image('assets/heart_half.png'),
     empty: Icon(Icons.favorite_border), //_image('assets/heart_border.png'),
   ),
   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
   onRatingUpdate: (r) {
     rating = r.toInt();
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
              onPressed: () {
                sendfeedback();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
