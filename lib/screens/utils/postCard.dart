import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:social/models/postList.dart';
import 'package:social/models/posts.dart';
import 'package:social/models/users.dart';
import 'package:http/http.dart';
import 'package:social/screens/utils/alert.dart';
import 'package:social/screens/utils/loading.dart';

class PostCard extends StatefulWidget {
  int id;
  Function removePost = () {};
  PostCard(this.id, this.removePost, {Key? key}) : super(key: key);

  @override
  PostCardState createState() => PostCardState();
}

class PostCardState extends State<PostCard> {
  bool loading = false;
  raiseError() {
    if (Provider.of<PostListModel>(context, listen: false)
        .postMap[widget.id]!
        .hasError) {
      showAlertDialog(
          context: context,
          title: Text(Provider.of<PostListModel>(context, listen: false)
              .postMap[widget.id]!
              .error));
    } else {
      showAlertDialog(context: context, title: Text("Some error occured"));
    }
  }

  postDetailMethod() {
    Navigator.pushNamed(context, '/post_detail', arguments: [
      Provider.of<PostListModel>(context, listen: false),
      widget.id
    ]);
  }

  changeLikedStatus() async {
    bool status = await Provider.of<PostListModel>(context, listen: false)
        .changeLikeStatus(widget.id);
    if (status == false)
      raiseError();
    print(status);
  }

  optionsFunction(String result) async {
    setState(() {
      if (result == 'Delete') {
        deletePost();
      } else if (result == 'Save') {
        _save();
      } else {}
    });
  }

  deletePost() async {
    bool success = await widget.removePost(widget.id);
    if (success) {
    } else {
      raiseError();
    }
  }

  void placeLike() async {
    Provider.of<PostListModel>(context, listen: false).addLike(widget.id);
  }

  _save() async {
    if (mounted)
      setState(() {
        loading = true;
      });
    var status = await Permission.storage.status;
    if (status.isDenied) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[
          Permission.storage]); // it should print PermissionStatus.granted
    }
    Response result = await get(Uri.parse(
        Provider.of<PostListModel>(context, listen: false)
            .postMap[widget.id]!
            .imageURL));

    var r = await ImageGallerySaver.saveImage(result.bodyBytes);
    if (r['isSuccess'])
      showAlertDialog(context: context, title: Text("Image saved"));
    else
      showAlertDialog(
          context: context,
          title: Text("Can't save file \n" + r['errorMessage'].toString()));
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  List<PopupMenuEntry<String>> getOptions() {
    List<PopupMenuEntry<String>> options = [];
    options.add(
      PopupMenuItem<String>(
        value: "Save",
        child: Row(
          children: [
            Row(
              children: [
                Icon(Icons.download),
                SizedBox(
                  width: 5,
                ),
                Text("Download"),
              ],
            ),
            SizedBox(
              width: 5.0,
            ),
          ],
        ),
      ),
    );
    if (Provider.of<PostListModel>(context, listen: false)
            .postMap[widget.id]!
            .userName ==
        Provider.of<User>(context, listen: false).userName)
      options.add(
        PopupMenuItem<String>(
          value: "Delete",
          child: Row(
            children: [
              Row(
                children: [
                  Icon(Icons.delete_outline),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Delete"),
                ],
              ),
              SizedBox(
                width: 5.0,
              ),
            ],
          ),
        ),
      );
    return options;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: placeLike,
      onTap: postDetailMethod,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      Provider.of<PostListModel>(context)
                          .postMap[widget.id]!
                          .userImageURL),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<PostListModel>(context)
                            .postMap[widget.id]!
                            .userName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(child: Text(Provider.of<PostListModel>(context)
                        .postMap[widget.id]!
                        .title)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 4 / 5,
                child: loading
                    ? Loading()
                    : Image.network(Provider.of<PostListModel>(context)
                        .postMap[widget.id]!
                        .imageURL)),
          ),
          Row(
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: changeLikedStatus,
                        icon: Provider.of<PostListModel>(context)
                                .postMap[widget.id]!
                                .liked
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(Icons.favorite_outline),
                      ),
                      Text(Provider.of<PostListModel>(context)
                          .postMap[widget.id]!
                          .likes
                          .toString())
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: FaIcon(FontAwesomeIcons.comment),
                      ),
                      Text(Provider.of<PostListModel>(context)
                          .postMap[widget.id]!
                          .comments
                          .toString()),
                    ],
                  ),
                ],
              ),
              PopupMenuButton<String>(
                  onSelected: optionsFunction,
                  itemBuilder: (BuildContext context) => getOptions()),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Divider()
        ],
      ),
    );
  }
}
