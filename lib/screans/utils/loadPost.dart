import 'package:flutter/material.dart';
import 'package:social/models/posts.dart';
import 'package:social/routing.dart';
import 'package:social/screans/utils/loading.dart';

class LoadPost extends StatefulWidget {
  int id;
  LoadPost({required this.id, Key? key}) : super(key: key);

  @override
  State<LoadPost> createState() => _LoadPostState();
}

class _LoadPostState extends State<LoadPost> {
  bool loading = false;

  gotoPostMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      PostModel post = await PostModel.fromJson({}).getPost(id: widget.id);
      Routing.PostPageReplacement(context, post);
    } catch (e) {}
    if (mounted) setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    gotoPostMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      loading: loading,
      fullscreen: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Error"),
          centerTitle: true,
        ),
        body: Center(
          child: Text("Can't load the post"),
        ),
      ),
    );
  }
}
