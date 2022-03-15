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


class PostCard extends StatefulWidget {
  bool on_home;
  PostModel post;
  Function deletePostMethod;
  bool defaultCollapsed;

  PostCard({required this.post, required this.deletePostMethod, this.on_home=false, this.defaultCollapsed=false, Key? key}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  User user = Hive.box('userBox').getAt(0) as User;
  bool colaps = false;
  bool loading=false;

  @override
  void initState() {
    super.initState();
    colaps = widget.defaultCollapsed;
  }

  likeMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      if (widget.post.liked)
        await widget.post.removeLike();
      else
        await widget.post.addLike();

      setState(() => widget.post);
    } on Exception catch( e){
      if (mounted) errorBox(context:context, error:e.toString().substring(11), errorTitle: 'Error'); 
    }
    if (mounted) setState(() => loading = false);
  }

  detailsPageMethod() async {    
    if (widget.on_home) {
      await Routing.PostPage(context, widget.post);
      setState(() {widget.post;});
    }
  }

  Widget androidOptionsBuilder(){
    return Container();
  }

  showOptions() {
    Platform.isAndroid 
    ? showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        height:200,
        child: (
          Column(children:  <Widget>[
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
          ?Expanded(
            child: CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: const Text('Delete'),
              onPressed: () {
                widget.deletePostMethod(widget.post);
                Navigator.pop(context);
              },
            ),
          ):Expanded(
            child: CupertinoActionSheetAction(
              isDestructiveAction: false,
              child: const Text('Detail'),
              onPressed: detailsPageMethod
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
          ?CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () {
              widget.deletePostMethod(widget.post);
              Navigator.pop(context);
            },
          ):CupertinoActionSheetAction(
            isDestructiveAction: false,
            child: const Text('Detail'),
            onPressed: detailsPageMethod
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
    var status = await Permission.storage.status;
    if (status.isPermanentlyDenied){
      errorBox(context: context, errorTitle: 'Error',error: "Storage permission is required for downloading image");   
    }
    if (status.isDenied)  {
      status = await Permission.storage.request();
      errorBox(context: context, errorTitle: 'Error',error: "Storage permission is required for downloading image");   
    }
    if (status.isGranted){
      try{      
      Response result = await get(Uri.parse(widget.post.imageUrl));
      dynamic success = await ImageGallerySaver.saveImage(result.bodyBytes);
      if(success['isSuccess'])
        errorBox(context: context, errorTitle: "Saved", error: "Saved to the device");
      }catch(e){
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
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      widget.post.userImageUrl),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: (){},
                        child: Text(
                          widget.post.userName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(child: Text(widget.post.title)),
              ],
            ),
          ),
          colaps
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 4 / 5,
                      child: Image.network(widget.post.imageUrl)),
                ),
          widget.on_home==false ? Container() : Row(
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      loading?Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: LoafingInternal(),
                      ):IconButton(
                          onPressed: likeMethod,
                          icon: Icon(
                            widget.post.liked?Icons.favorite:Icons.favorite_border,
                            color: widget.post.liked?Colors.red:Colors.black,
                          )),
                      Text(widget.post.likes.toString())
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
              IconButton(
                  onPressed: showOptions, icon: Icon(CupertinoIcons.ellipsis))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Divider()
        ],
      ),
    );
  }
}
