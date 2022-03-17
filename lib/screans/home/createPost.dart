// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:social/models/posts.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/textInput.dart';
import 'package:social/screans/utils/imagePicker.dart';
import 'package:social/vars.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final cropKey = GlobalKey<CropState>();
  File? image;
  String title = '';
  bool loading = false;

  Future createPostMethod() async {
    if (mounted) setState(() => loading = true);

    FocusManager.instance.primaryFocus?.unfocus();

    if (image == null) {
      if (mounted)
        errorBox(
            context: context,
            errorTitle: 'Error',
            error: ErrorStrings.image_needed);
    } else if (title == '') {
      if (mounted)
        errorBox(
            context: context,
            errorTitle: 'Error',
            error: ErrorStrings.title_needed);
    } else {
      try {
        if (image == null) {
          throw Exception(ErrorStrings.image_needed);
        }
        image = await cropMethod(image!);
        await PostModel.createPost(title: title, image: image!);
        Navigator.of(context).pop();
        Routing.wrapperPage(context);
      } on Exception catch (e) {
        if (mounted)
          errorBox(
              context: context,
              error: e.toString().substring(11),
              errorTitle: 'Error');
      }
    }
    if (mounted) setState(() => loading = false);
  }

  getImageMethod(String fromWhere) async {
    XFile? localImage;
    if (fromWhere == 'camera') {
      localImage = await getImageFromCamera(context);
    } else if (fromWhere == 'photos') {
      localImage = await getImageFromPhtos(context);
    }
    if (localImage != null) if (mounted)
      setState(() => image = File(localImage!.path));
  }

  Future<File> cropMethod(File fileImage) async {
    return await ImageCrop.cropImage(
      file: File(fileImage.path),
      scale: cropKey.currentState!.scale,
      area: cropKey.currentState!.area!,
    );
  }

  fromWhereChooser() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Image from'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.camera), Text('  Camera')],
            ),
            onPressed: () {
              Navigator.pop(context);
              getImageMethod('camera');
            },
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.photo), Text('  Photos')],
            ),
            onPressed: () {
              Navigator.pop(context);
              getImageMethod('photos');
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
    return Loading(
      fullscreen: true,
      loading: loading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Post"),
          // flexibleSpace: Image(
          //   image: AssetImage('assets/background.png'),
          //   fit: BoxFit.cover,
          // ),
          // backgroundColor: Colors.transparent,
          actions: [
            IconButton(onPressed: createPostMethod, icon: Icon(Icons.send)),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextInput(
                    initialText: title,
                    labelText: InfoStrings.title_info,
                    maxlength: 200,
                    keyboardtype: TextInputType.multiline,
                    maxlines: null,
                    onChanged: (val) => title = val,
                  )),
              SizedBox(
                height: 20.0,
              ),
              image == null
                  ? InkWell(
                      child: Image.asset('assets/addimage.png'),
                      onTap: fromWhereChooser,
                    )
                  : InkWell(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width * 720 / 1280,
                        width: MediaQuery.of(context).size.width,
                        child: image == null
                            ? Container()
                            : Crop(
                                key: cropKey,
                                image: FileImage(image!),
                                aspectRatio: 5 / 4,
                              ),
                      ),
                      onTap: fromWhereChooser),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
