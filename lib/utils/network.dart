import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:social/models/users.dart';
import 'package:social/utils/staticStrings.dart';

class InternalNetwork {
  String error = '';
  get hasError => error == '' ? false : true;

  Future<Map> requestIfPossible({
    Map<String, String> body = const {},
    Iterable<MultipartFile> files = const [],
    int expectedCode = 200,
    String requestMethod = 'GET',
    required String url,
  }) async {
    error = "";
    Map<String, String> headers = {};
    if (Hive.box('userBox')
        .isNotEmpty) if ((Hive.box('userBox').getAt(0) as User).id != 0)
      headers = {
        'Authorization':
            'Token ${(Hive.box('userBox').getAt(0) as User).token}',
        "Device": await (Hive.box('userBox').getAt(0) as User).getDeviceToekn(),
      };
    // Check for internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none)
      throw Exception("Internet not available");

    Response response;
    var uri = Uri.parse(StaticStrings.base_url + url);
    var request = MultipartRequest(requestMethod, uri);
    request.fields.addAll(body);
    request.headers.addAll(headers);
    request.files.addAll(files);

    // Send request
    try {
      response = await Response.fromStream(await request.send());
    } on Exception catch (e) {
      error = "Can't connect to the server";
      return {};
    }
    Map data = {};
    try {
      data = data = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      error = "Server error occured";
      print(response.body);
      return {};
    }
    try {
      if (response.statusCode == expectedCode) {
        return data;
      } else {
        error = data.values.toList()[0][0].toString();
        return {};
      }
    } catch (e) {
      error = "Request parsing error";
      return {};
    }
  }
}
