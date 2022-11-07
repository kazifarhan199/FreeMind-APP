import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:hive/hive.dart';
import 'package:social/models/request.dart';
import 'package:social/vars.dart';

part 'users.g.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  String userName;

  @HiveField(1)
  String userImage;

  @HiveField(2)
  String email;

  @HiveField(3)
  int id;

  @HiveField(4)
  int gid;

  @HiveField(5)
  String token;

  @HiveField(6)
  bool surveyGiven = false;

  User(
      {required this.userName,
      required this.userImage,
      required this.email,
      required this.id,
      required this.gid,
      required this.token});

  static Future<String> getDeviceToekn() async {
    return (await messaging.getToken())!;
  }

  static User fromJson(Map data) {
    String userName = data['username'] ?? 'UserName';
    String email = data['email'] ?? 'Email';
    String token = data['token'] ?? 'Token';
    String userImage = data['image'] ?? '/media/image/notfound.jpg';
    int id = data['id'] ?? 0;
    int gid = data['gid'] ?? 0;
    return User(
        userName: userName,
        userImage: userImage,
        email: email,
        id: id,
        gid: gid,
        token: token);
  }

  Map data = {};
  String get imageUrl => base_url + this.userImage;
  bool get isloggedin => this.id == 0 ? false : true;

  static Future<bool> addGroup(gid) async {
    try {
      User user = Hive.box('userBox').getAt(0) as User;
      user.gid = gid;
      await Hive.box("userBox").put(0, user);
      return true;
    } catch (e) {
      throw e;
    }
  }

  static Future<bool> login(
      {required String userName, required String password}) async {
    if (userName == ''
        ? true
        : password == ''
            ? true
            : false) {
      throw Exception(ErrorStrings.all_fiields_needed);
    }

    try {
      Map data = await requestIfPossible(
        url: '/accounts/login/',
        requestMethod: 'POST',
        body: {
          "username": userName,
          "password": password,
          "devicetoken": await User.getDeviceToekn(),
          "devicename": "deviceName",
          "devicetype": Platform.operatingSystem,
        },
      );
      User user = User.fromJson(data);
      await Hive.box("userBox").put(0, user);
      return true;
    } on Exception catch (e) {
      throw e;
    }
  }

  static Future<bool> register(
      {required String userName,
      required String email,
      required String password,
      required String re_password}) async {
    if (userName == ''
        ? true
        : email == ''
            ? true
            : password == ''
                ? true
                : re_password == ''
                    ? true
                    : false) {
      throw Exception(ErrorStrings.all_fiields_needed);
    }

    if (password != re_password) {
      throw Exception("Passwords do not match");
    }

    try {
      Map data = await requestIfPossible(
        url: '/accounts/register/',
        requestMethod: 'POST',
        body: {
          "username": userName,
          "email": email,
          "password": password,
          "devicetoken": await User.getDeviceToekn(),
          "devicename": "somename",
          "devicetype": Platform.operatingSystem,
        },
      );
      User user = User.fromJson(data);
      await Hive.box("userBox").put(0, user);
      return true;
    } on Exception catch (e) {
      throw e;
    }
  }

  static Future<bool> sendPasswordResetEmail({required String email}) async {
    if (email == '' ? true : false) {
      throw Exception(ErrorStrings.email_needed);
    }

    try {
      Map data = await requestIfPossible(
        url: '/accounts/reset/',
        requestMethod: 'POST',
        expectedCode: 201,
        body: {
          "email": email,
        },
      );
      return true;
    } on Exception catch (e) {
      throw e;
    }
  }

  static Future<bool> passwordReset(
      {required String otp,
      required String email,
      required String password,
      required String re_password}) async {
    if (otp == ''
        ? true
        : password == ''
            ? true
            : re_password == ''
                ? true
                : false) {
      throw Exception(ErrorStrings.all_fiields_needed);
    }

    if (password != re_password) {
      throw Exception(ErrorStrings.password_not_match);
    }

    try {
      Map data = await requestIfPossible(
        url: '/accounts/reset/',
        requestMethod: 'POST',
        expectedCode: 200,
        body: {
          "email": email,
          "otp": otp,
          "password": password,
        },
      );
      return true;
    } on Exception catch (e) {
      throw e;
    }
  }

  static Future<bool> logout() async {
    try {
      requestIfPossible(
        url: '/accounts/logout/',
        requestMethod: 'DELETE',
        expectedCode: 202,
        body: {
          "devicetoken": await User.getDeviceToekn(),
        },
      );
      await Future.delayed(Duration(seconds: 1));
      // This is so that the request method has enough time to send the logout request
      //  (we want to be able to retrive the user token from hive before removing it)
      await Hive.box("userBox").delete(0);
      User user = User.fromJson({});
      await Hive.box("userBox").put(0, user);
      return true;
    } on Exception catch (e) {
      await Hive.box("userBox").delete(0);
      return true;
    }
  }

  static Future<bool> profileEdit(
      {required String email, required String userName, required image}) async {
    if (email == ''
        ? true
        : userName == ''
            ? true
            : false) {
      throw Exception(ErrorStrings.all_fiields_needed);
    }

    try {
      Map data = await requestIfPossible(
        url: '/accounts/edit/',
        requestMethod: 'PUT',
        expectedCode: 200,
        body: {
          "email": email,
          "username": userName,
        },
        files: image == null
            ? []
            : [
                await MultipartFile.fromPath(
                  'img_obj',
                  image.path,
                )
              ],
      );
      data['gid'] = (Hive.box('userBox').getAt(0) as User).gid;
      User user = User.fromJson(data);
      await Hive.box("userBox").put(0, user);
      return true;
    } on Exception catch (e) {
      throw e;
    }
  }

  static Future<bool> passwordChange(
      {required String password, required String re_password}) async {
    if (password == ''
        ? true
        : re_password == ''
            ? true
            : false) {
      throw Exception(ErrorStrings.all_fiields_needed);
    }

    if (password != re_password) {
      throw Exception(ErrorStrings.password_not_match);
    }

    try {
      Map data = await requestIfPossible(
        url: '/accounts/edit/',
        requestMethod: 'PUT',
        expectedCode: 200,
        body: {
          "password": password,
        },
      );
      return true;
    } on Exception catch (e) {
      throw e;
    }
  }

  static Future<bool> profile() async {
    try {
      Map data = await requestIfPossible(
        url: '/accounts/profile/',
        requestMethod: 'GET',
        expectedCode: 200,
      );

      User user = User.fromJson(data);
      await Hive.box("userBox").put(0, user);
      return true;
    } catch (e) {
      throw e;
    }
  }
}
