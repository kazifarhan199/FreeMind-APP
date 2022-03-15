// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'package:image_picker/image_picker.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:permission_handler/permission_handler.dart';

Future<XFile?> getImageFromCamera(context) async {
  final ImagePicker _picker = ImagePicker();
  String localError = '';
  
  if (await Permission.camera.request().isGranted) {
    XFile? localImage = await _picker.pickImage(source: ImageSource.camera);
    return localImage;
  }else{
    localError = 'Camera persmission is needed for this option';
    errorBox(context: context, errorTitle: 'Error', error: localError);
  }
}

Future<XFile?> getImageFromPhtos(context) async {
  await Permission.photos.request();
  final ImagePicker _picker = ImagePicker();
  String localError = '';

  if (await Permission.photos.request().isLimited ) {
    XFile? localImage = await _picker.pickImage(source: ImageSource.gallery);
    return localImage;
  } else if (await Permission.photos.request().isGranted ) {
    XFile? localImage = await _picker.pickImage(source: ImageSource.gallery);
    return localImage;
  }else{
    localError = 'Photos persmission is needed for this option';
    errorBox(context: context, errorTitle: 'Error', error: localError);
  }
}

