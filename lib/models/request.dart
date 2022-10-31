import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:social/models/users.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:social/vars.dart';

import '../routing.dart';

Future<Map> requestIfPossible({
  Map<String, String> body = const {},
  Iterable<MultipartFile> files = const [],
  int expectedCode = 200,
  String requestMethod = 'GET',
  required String url,
}) async {
  // Check for internet
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none)
    throw Exception(ErrorStrings.internet_needed);

  Map<String, String> headers = {};
  if (Hive.box('userBox').isNotEmpty)
  // ignore: curly_braces_in_flow_control_structures
  if ((Hive.box('userBox').getAt(0) as User).id != 0) {
    User user = Hive.box('userBox').getAt(0) as User;
    headers = {
      'Authorization': 'Token ${user.token}',
      "Device": await User.getDeviceToekn(),
    };
  }

  Response response;
  print(base_url + url);

  var uri = Uri.parse(base_url + url);
  var request = MultipartRequest(requestMethod, uri);
  request.fields.addAll(body);
  request.headers.addAll(headers);
  request.files.addAll(files);
  // Send request
  try {
    response = await Response.fromStream(await request.send());
    print(response.body);
  } catch (e) {
    throw Exception(ErrorStrings.server_needed);
  }

  Map data = {};

  try {
    data = data = jsonDecode(utf8.decode(response.bodyBytes));
  } catch (e) {
    throw Exception(ErrorStrings.server_error);
  }
  try {
    if (response.statusCode == expectedCode) {
      return data;
    } else {
      print(data);
      if (data.keys.contains('non_field_errors')) {
        throw Exception(data['non_field_errors'][0]);
      } else if (data.keys.contains('detail')) {
        if (data['detail'] == 'Invalid page.') return {'results': []};
        if (data['detail'] == 'Invalid token.') User.logout();
        throw Exception(ErrorStrings.loggedout);
        throw Exception(data['detail']);
      }
      throw Exception(data.values.toList()[0][0].toString());
    }
  } catch (e) {
    throw e;
  }
}
