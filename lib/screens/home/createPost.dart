import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social/models/posts.dart';
import 'package:social/screens/utils/alert.dart';
import 'package:social/screens/utils/image.dart';
import 'package:social/screens/utils/loading.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost>
    with AutomaticKeepAliveClientMixin {
  bool loading = false;
  String title = '';
  File? image;
  PostModel post = PostModel({});

  @override
  bool get wantKeepAlive => true;

  postsPageMethod() async {
    if (DefaultTabController.of(context)!.index == 1) {
      exit(0);
    } else {
      DefaultTabController.of(context)!.animateTo(1);
    }
  }

  raiseError() {
    if (post.hasError) {
      showAlertDialog(context: context, title: Text(post.error));
    } else {
      showAlertDialog(context: context, title: Text("Some error occured"));
    }
  }

  Future _getImageMethod() async {
    FocusScope.of(context).unfocus();
    getImageMethod(
      context: context,
      callback: (img) => setState(() => image = img),
    );
  }

  Future createPostMethod() async {
    if (mounted) setState(() => loading = true);
    bool success = await post.createPost(title, image);
    if (success) {
      image = null;
      title = "";
      Navigator.of(context).pushReplacementNamed('/');
    } else {
      raiseError();
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => postsPageMethod(),
      child: loading
          ? Loading()
          : Scaffold(
              appBar: AppBar(
                actions: [
                  Tooltip(
                    message: "Create post",
                    child: IconButton(
                        icon: Icon(
                          Icons.check_circle_outline_rounded,
                          size: 40.0,
                        ),
                        onPressed: createPostMethod),
                  )
                ],
                title: Text('Create Post'),
                leading: Tooltip(
                  message: "Go back",
                  child: IconButton(
                      icon: Icon(Icons.arrow_back), onPressed: postsPageMethod),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextFormField(
                          onChanged: (value) => title = value,
                          keyboardType: TextInputType.multiline,
                          maxLength: 200,
                          maxLines: null,
                          initialValue: title,
                          decoration: InputDecoration(
                            labelText: "Title",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 4 / 5,
                    child: InkWell(
                      onTap: _getImageMethod,
                      child: image == null
                          ? Container(
                              child: Center(
                                child: SizedBox(
                                    child: Image.asset(
                                  'assets/add_image.png',
                                  width: 120,
                                )),
                              ),
                            )
                          : Image.file(image!),
                    ),
                  ),
                ]),
              ),
            ),
    );
  }
}
