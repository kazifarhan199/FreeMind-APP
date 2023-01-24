// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:social/models/posts.dart';
import 'package:social/models/users.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  bool on_home;
  PostModel post;
  Function deletePostMethod, refreshMethod;
  bool defaultCollapsed, hasUserDetails;

  static defaultFunction() {}

  PostCard(
      {required this.post,
      required this.deletePostMethod,
      this.refreshMethod = defaultFunction,
      this.on_home = false,
      this.defaultCollapsed = false,
      this.hasUserDetails = true,
      Key? key})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  User user = Hive.box('userBox').getAt(0) as User;
  bool colaps = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    colaps = widget.defaultCollapsed;
  }

  profileMethod({required int uid}) {
    Routing.profilePage(context, uid: uid);
  }

  likeMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      if (widget.post.liked)
        await widget.post.removeLike();
      else
        await widget.post.addLike();

      setState(() => widget.post);
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }
    if (mounted) setState(() => loading = false);
  }

  detailsPageMethod() async {
    if (widget.on_home) {
      await Routing.PostPage(context, widget.post);
      setState(() {
        widget.post;
      });
    }
  }

  groupsDetailPageMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      Routing.groupsDetailPage(context,
          gid: widget.post.group, doublePop: false);
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }
    if (mounted) setState(() => loading = false);
  }

  Widget androidOptionsBuilder() {
    return Container();
  }

  profilePageMethod() {
    if (widget.on_home) {
      profileMethod(uid: widget.post.uid);
    } else {}
  }

  void _launchURL(String url) async {
    try {
      if (!await launch(url)) throw Exception('Could not launch $url');
    } catch (e) {
      errorBox(
          context: context,
          errorTitle: "Error",
          error: e.toString().substring(11));
    }
  }

  showOptions() {
    Platform.isAndroid
        ? showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => Container(
                  height: 300,
                  child: (Column(
                    children: <Widget>[
                      Expanded(
                        child: CupertinoDialogAction(
                          child: const Text('Download'),
                          onPressed: () {
                            downloadMethod();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Divider(),
                      user.userName == widget.post.userName
                          ? Expanded(
                              child: CupertinoActionSheetAction(
                                isDestructiveAction: true,
                                child: const Text('Delete'),
                                onPressed: () {
                                  widget.deletePostMethod(widget.post);
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          : Expanded(
                              child: CupertinoActionSheetAction(
                                  isDestructiveAction: false,
                                  child: const Text('Detail'),
                                  onPressed: detailsPageMethod),
                            ),
                      Divider(),
                      Expanded(
                        child: CupertinoDialogAction(
                          child: const Text('Like/Unlike'),
                          onPressed: () async {
                            Navigator.pop(context);
                            await likeMethod();
                            widget.refreshMethod();
                          },
                        ),
                      ),
                      Divider(),
                      Expanded(
                        child: CupertinoDialogAction(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  )),
                ))
        : showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
              title: const Text('Post'),
              actions: <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                  child: const Text('Download'),
                  onPressed: () {
                    downloadMethod();
                    Navigator.pop(context);
                  },
                ),
                user.userName == widget.post.userName
                    ? CupertinoActionSheetAction(
                        isDestructiveAction: true,
                        child: const Text('Delete'),
                        onPressed: () {
                          widget.deletePostMethod(widget.post);
                          Navigator.pop(context);
                        },
                      )
                    : CupertinoActionSheetAction(
                        isDestructiveAction: false,
                        child: const Text('Detail'),
                        onPressed: detailsPageMethod),
                CupertinoActionSheetAction(
                  child: const Text('Like/Unlike'),
                  onPressed: () async {
                    Navigator.pop(context);
                    await likeMethod();
                    widget.refreshMethod();
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

  downloadMethod() async {
    var status = await Permission.storage.request();
    status = await Permission.storage.status;
    if (status.isPermanentlyDenied) {
      errorBox(
          context: context,
          errorTitle: 'Error',
          error: "Storage permission is required for downloading image");
    }
    if (status.isDenied) {
      errorBox(
          context: context,
          errorTitle: 'Error',
          error: "Storage permission is required for downloading image");
    }
    if (status.isGranted) {
      try {
        Response result = await get(Uri.parse(widget.post.imageUrl));
        dynamic success = await ImageGallerySaver.saveImage(result.bodyBytes);
        if (success['isSuccess'])
          errorBox(
              context: context,
              errorTitle: "Saved",
              error: "Saved to the device");
      } catch (e) {
        errorBox(context: context, errorTitle: "Error", error: e.toString());
      }
    }
  }

  colapsUncolapsMethod() {
    if (colaps == true)
      setState(() => colaps = false);
    else
      setState(() => colaps = true);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: () {},
      onTap: detailsPageMethod,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.hasUserDetails
                ? Row(
                    children: [
                      InkWell(
                        onTap: profilePageMethod,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.post.userImageUrl),
                        ),
                      ),
                      InkWell(
                          onTap: profilePageMethod,
                          child: SizedBox(width: 10.0)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.on_home
                                  ? MediaQuery.of(context).size.width * 0.7
                                  : MediaQuery.of(context).size.width * 0.58,
                              child: Text(
                                widget.post.userName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: groupsDetailPageMethod,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            widget.post.groupImageUrl),
                                        radius: 10.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      width: widget.on_home
                                          ? MediaQuery.of(context).size.width *
                                              0.5
                                          : MediaQuery.of(context).size.width *
                                              0.4,
                                      child: Text(
                                        widget.post.groupName,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      widget.on_home
                          ? Container()
                          : IconButton(
                              onPressed: colapsUncolapsMethod,
                              icon: colaps
                                  ? Icon(Icons.arrow_drop_up_rounded)
                                  : Icon(Icons.arrow_drop_down_circle_rounded)),
                      IconButton(
                          onPressed: showOptions,
                          icon: Icon(CupertinoIcons.ellipsis))
                    ],
                  )
                : Container(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(child: Text(widget.post.title)),
              ],
            ),
          ),
          widget.post.isRecommendation
              ? Container()
              : colaps
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * 4 / 5,
                          child: FittedBox(
                            child: Image.network(
                              widget.post.imageUrl,
                            ),
                            fit: BoxFit.fitWidth,
                          )),
                    ),
          widget.on_home == false
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                loading
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: LoafingInternal(),
                                      )
                                    : IconButton(
                                        onPressed: likeMethod,
                                        icon: Icon(
                                          widget.post.liked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: widget.post.liked
                                              ? Colors.red
                                              : Colors.black,
                                        )),
                                Text(widget.post.likes.toString()),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: detailsPageMethod,
                                  icon: FaIcon(FontAwesomeIcons.comment),
                                ),
                                Text(widget.post.comments.toString()),
                              ],
                            ),
                          ],
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4.0),
                      child: Row(
                        children: [
                          Text(
                            DateFormat('MMMM dd, yy')
                                .format(widget.post.datetime),
                            style: TextStyle(
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          widget.post.link == ""
              ? Container()
              : Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          child: Text("Link to read more"),
                          onPressed: () {
                            _launchURL(widget.post.link);
                          }),
                    ),
                  ],
                ),
          Divider(),
        ],
      ),
    );
  }
}
