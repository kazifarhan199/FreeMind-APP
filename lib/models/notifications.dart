import 'package:social/models/request.dart';
import 'package:social/vars.dart';

class NotificationsModel {
  String image, type, title, body;
  int send_object, object_id;
  bool moreAvailable = true;
  get imageURL => base_url + this.image;

  NotificationsModel({
    required this.object_id,
    required this.send_object,
    required this.type,
    required this.image,
    required this.title,
    required this.body,
  });

  static fromJson(Map data) {
    int object_id = data['object_id'] ?? 0;
    int send_object = data['send_object'] ?? 0;
    String type = data['type'] ?? "";
    String image = data['user_image'] ?? "/media/image/notfound.jpg";
    String title = data['title'] ?? "";
    String body = data['body'] ?? "";

    return NotificationsModel(
        object_id: object_id,
        send_object: send_object,
        type: type,
        image: image,
        title: title,
        body: body);
  }

  Future<List<NotificationsModel>> getNotificationsList(
      {required int page}) async {
    try {
      Map data = await requestIfPossible(
        url: '/notifications/',
        requestMethod: 'GET',
        expectedCode: 200,
      );
      if (data['notifications'].length == 0) {
        this.moreAvailable = false;
        return [];
      }
      return data['notifications']
          .map((d) => NotificationsModel.fromJson(d))
          .toList()
          .cast<NotificationsModel>();
    } on Exception catch (e) {
      throw e;
    }
  }
}
