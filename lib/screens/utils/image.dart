import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> _cropSquareImageMethod({image}) async {
  File? _newimage = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'PhamilyHealth',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          hideBottomControls: true),
      iosUiSettings: IOSUiSettings(
        title: 'PhamilyHealth',
      ));
  return _newimage;
  return File(image.path);
}

Future<File?> _cropImageMethod({image}) async {
  File? _newimage = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [CropAspectRatioPreset.ratio5x4],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'PhamilyHealth',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          hideBottomControls: true),
      iosUiSettings: IOSUiSettings(
        title: 'PhamilyHealth',
      ));
  return _newimage;
}

Future<File?> _getImageMethod({context, type = 1, square = false}) async {
  final picker = ImagePicker();

  Navigator.of(context).pop();

  var pickedFile;
  if (type == 1)
    pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxWidth: 1920.0, maxHeight: 1920.0);
  else
    pickedFile = await picker.getImage(
        source: ImageSource.camera, maxWidth: 1920.0, maxHeight: 1920.0);

  if (pickedFile != null) {
    File? _newimage;
    if (square)
      _newimage = await _cropSquareImageMethod(image: pickedFile);
    else
      _newimage = await _cropImageMethod(image: pickedFile);

    if (_newimage != null)
      return _newimage;
    else
      return null;
  }
}

getImageMethod(
    {required context, required Function? callback, bool square = false}) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Tooltip(
                message: "Camera",
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Tooltip(
                    message: "Camera",
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.cameraRetro,
                        size: 40.0,
                      ),
                      onPressed: () async {
                        File? tmp = await _getImageMethod(
                            context: context, square: square, type: 0);
                        callback!(tmp);
                      },
                      iconSize: 60.0,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Tooltip(
                message: "Gallery",
                child: Tooltip(
                  message: "Galery",
                  child: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.fileImage,
                      size: 40.0,
                    ),
                    onPressed: () async {
                      File? tmp = await _getImageMethod(
                          context: context, square: square);
                      callback!(tmp);
                    },
                    iconSize: 60.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
