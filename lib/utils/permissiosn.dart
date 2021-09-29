import 'package:permission_handler/permission_handler.dart';

getPermissionForPost() async {
  final status = await Permission.locationWhenInUse.request();
  if (status == PermissionStatus.granted) {
    print('Permission granted');
  } else if (status == PermissionStatus.denied) {
    print(
        'Denied. Show a dialog with a reason and again ask for the permission.');
  } else if (status == PermissionStatus.permanentlyDenied) {
    print('Take the user to the settings page.');
  }
}

