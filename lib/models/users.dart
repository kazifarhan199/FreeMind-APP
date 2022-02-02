import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:social/models/member.dart';
import 'package:social/utils/network.dart';
import 'package:social/utils/staticStrings.dart';
import 'package:http/http.dart';

part 'users.g.dart';

@HiveType(typeId: 0)
class User extends ChangeNotifier {
  @HiveField(0)
  int id = 0;
  @HiveField(1)
  int gid = 0;
  @HiveField(2)
  String userName = 'My user name';
  @HiveField(3)
  String email = '';
  @HiveField(4)
  String token = '';
  @HiveField(5)
  String image = '';
  @HiveField(6)
  String firstName = '';
  @HiveField(7)
  String lastName = '';

  String groupName = "";
  List<Member> members = [];

  String error = '';

  InternalNetwork network = InternalNetwork();
  Map data = {};

  loadBareUser(Map data) {
    this.userName = data['username'] ?? '';
    this.email = data['email'] ?? '';
    this.token = data['token'] ?? '';
    this.image = data['image'] ?? '';
    this.id = data['id'] ?? 0;
    this.gid = data['gid'] ?? 0;
  }

  loadGroup(Map data) {
    this.groupName = data['group_name'] ?? "";
    this.members = data['members'] != null
        ? data['members'].map(MemberFromJson).toList().cast<Member>()
        : [];
  }

  Member MemberFromJson(dynamic data) {
    return Member(data);
  }

  Future<String> getDeviceToekn() async {
    String token = (await FirebaseMessaging.instance.getToken())!;
    return token;
  }

  String get imageURL => this.image != ''
      ? StaticStrings.base_url + this.image
      : "https://wallup.net/wp-content/uploads/2016/01/136090-nature-sea-island-748x561.jpg";
  bool get hasError => this.error == '' ? false : true;

  bool isLoggedIn() {
    if (id == 0)
      return false;
    else
      return true;
  }

  bool isInAGroup() {
    if (gid == 0)
      return false;
    else
      return true;
  }

  Future<bool> register(String username, email, password, passwordre) async {
    // Get response
    error = '';
    if (username == '') {
      error = "Username is required";
      return false;
    }
    if (email == '') {
      error = "Email is required";
      return false;
    }
    if (password == '') {
      error = "Password is required";
      return false;
    }
    if (password != passwordre) {
      error = "Passwords do not match";
      return false;
    }

    data = await network.requestIfPossible(
      url: '/accounts/register/',
      requestMethod: 'POST',
      body: {
        "username": username,
        "email": email,
        "password": password,
        "devicetoken": await this.getDeviceToekn(),
        "devicename": "somename",
        "devicetype": "android",
      },
    );

    if (await network.hasError) {
      error = network.error;
      return false;
    } else {
      loadBareUser(data);
      await Hive.box("userBox").put(0, this);
      notifyListeners();
      return true;
    }
  }

  Future<bool> login(String email, String password) async {
    error = '';
    if (email == '') {
      error = "Email is required";
      return false;
    }
    if (password == '') {
      error = "Password is required";
      return false;
    }

    if (await network.hasError) {
      error = network.error;
      return false;
    } else {
      data = await network.requestIfPossible(
        url: '/accounts/login/',
        requestMethod: 'POST',
        body: {
          "username": email,
          "password": password,
          "devicetoken": await this.getDeviceToekn(),
          "devicename": "somename",
          "devicetype": "android",
        },
      );
      loadBareUser(data);
      await Hive.box("userBox").put(0, this);
      notifyListeners();
      return true;
    }


  }

  Future<bool> logout() async {
    error = '';

    Map tmp_data = await network.requestIfPossible(
      url: '/accounts/logout/',
      requestMethod: 'DELETE',
      expectedCode: 202,
      body: {
        "devicetoken": await this.getDeviceToekn(),
      },
    );
    // if (network.hasError) {
    //   error = network.error;
    //   return false;
    // } else {
    Map data = {
      "username": "",
      "email": "",
      "id": 0,
      "token": "",
      "image": "",
    };
    loadBareUser(data);
    await Hive.box("userBox").put(0, this);
    notifyListeners();
    return true;
    // }
  }

  Future<bool> profile() async {
    error = '';

    data = await network.requestIfPossible(
      url: '/accounts/profile/',
      requestMethod: 'GET',
      expectedCode: 200,
    );
    // print(data);
    if (await network.hasError) {
      error = network.error;
      return false;
    } else {
      loadBareUser(data);
      await Hive.box("userBox").put(0, this);
      notifyListeners();
      return true;
    }
  }

  Future<bool> sendotp(String email) async {
    error = '';
    if (email == '') {
      error = "Email is required";
      return false;
    }

    data = await network.requestIfPossible(
      url: '/accounts/reset/',
      requestMethod: 'POST',
      expectedCode: 201,
      body: {
        "email": email,
      },
    );

    if (await network.hasError) {
      error = network.error;
      return false;
    } else {
      return true;
    }
  }

  Future<bool> varifyotp(String email, otp) async {
    error = '';
    if (email == '') {
      error = "Email is required";
      return false;
    }
    if (otp == '') {
      error = "OTP is required";
      return false;
    }

    data = await network.requestIfPossible(
      url: '/accounts/reset/',
      requestMethod: 'POST',
      expectedCode: 200,
      body: {
        "email": email,
        "otp": otp,
      },
    );

    if (await network.hasError) {
      error = network.error;
      return false;
    } else {
      return true;
    }
  }

  Future<bool> passwordreset(String email, otp, password, passwordre) async {
    error = '';
    if (email == '') {
      error = "Email is required";
      return false;
    }
    if (otp == '') {
      error = "OTP is required";
      return false;
    }
    if (password == '') {
      error = "Password is required";
      return false;
    }
    if (password != passwordre) {
      error = "Passwords do not match";
      return false;
    }

    data = await network.requestIfPossible(
      url: '/accounts/reset/',
      requestMethod: 'POST',
      expectedCode: 200,
      body: {
        "email": email,
        "otp": otp,
        "password": password,
      },
    );

    if (await network.hasError) {
      error = network.error;
      return false;
    } else {
      return true;
    }
  }

  Future<bool> edit(String userName, String email, File? image) async {
    error = '';
    // await Future.delayed(Duration(seconds: 3));

    data = await network.requestIfPossible(
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

    if (await network.hasError) {
      error = network.error;
      return false;
    } else {
      loadBareUser(data);
      await Hive.box("userBox").put(0, this);
      notifyListeners();
      return true;
    }
    // get data and loadBareUser
  }

  Future<bool> changePassword(String password, passwordre) async {
    error = '';
    if (password == '') {
      error = "Password is required";
      return false;
    }
    if (password != passwordre) {
      error = "Passwords do not match";
      return false;
    }

    data = await network.requestIfPossible(
      url: '/accounts/edit/',
      requestMethod: 'PUT',
      expectedCode: 200,
      body: {
        "password": password,
      },
    );

    if (await network.hasError) {
      error = network.error;
      return false;
    } else {
      loadBareUser(data);
      return true;
    }
  }

  Future<bool> groupCreate(groupname) async {
    error = '';
    if (groupname == '') {
      error = "Group name is required";
      return false;
    }

    data = await network.requestIfPossible(
      url: '/groups/create/',
      requestMethod: 'POST',
      expectedCode: 201,
      body: {
        "group_name": groupname,
      },
    );

    if (await network.hasError) {
      error = network.error;
      return false;
    } else {
      loadGroup(data);
      return true;
    }
  }

  Future<Member> varifyGroupMember(String email) async {
    error = '';
    if (email == '') {
      error = "Email is required";
      return Member({{}});
    }
    data = await network.requestIfPossible(
      url: '/groups/members/',
      body: {
        'email': email,
      },
      requestMethod: 'GET',
      expectedCode: 200,
    );

    if (await network.hasError) {
      error = network.error;
      return Member({});
    } else {
      return Member(data);
    }
  }

  Future<bool> editGroup(List<String> emailsToAdd, String name) async {
    error = '';

    if (name == '') {
      error = "Group name is required";
      return false;
    }

    if (name != groupName) {
      data = await network.requestIfPossible(
        url: '/groups/members/',
        body: {
          'email': email,
        },
        requestMethod: 'GET',
        expectedCode: 200,
      );
      if (await network.hasError) {
        error = network.error;
        return false;
      }
    }
    if (emailsToAdd.isNotEmpty) {
      for (var email in emailsToAdd) {
        data = await network.requestIfPossible(
          url: '/groups/members/',
          body: {
            'email': email,
          },
          requestMethod: 'POST',
          expectedCode: 201,
        );
        if (await network.hasError) {
          error = network.error;
          return false;
        }
      }
    }
    return true;
  }

  Future<bool> getGroup() async {
    error = "";

    data = await network.requestIfPossible(
      url: '/groups/',
      requestMethod: 'GET',
      expectedCode: 200,
    );

    if (await network.hasError) {
      error = network.error;
      return false;
    } else {
      loadGroup(data);
      notifyListeners();
      return true;
    }
  }

  Future<bool> groupRemoveMember(String email) async {
    error = '';
    if (email == '') {
      error = "Email is required";
      return false;
    }

    data = await network.requestIfPossible(
      url: '/groups/members/',
      body: {
        'email': email,
      },
      requestMethod: 'DELETE',
      expectedCode: 202,
    );
    if (await network.hasError) {
      error = network.error;
      return false;
    }

    return true;
  }

  Future<bool> addDevice() async {
    error = '';
    await Future.delayed(Duration(seconds: 3));
    return true;
  }

  Future<bool> removeDevice() async {
    error = '';
    await Future.delayed(Duration(seconds: 3));
    return true;
  }
}
