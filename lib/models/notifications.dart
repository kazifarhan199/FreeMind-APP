import 'package:social/models/request.dart';
import 'package:social/models/vars.dart';

class NotificationsModel {
  String image, text;
  int post, postComment, postLike;
  bool moreAvailable = true;
  get imageURL => base_url + this.image;

  NotificationsModel(
      {required this.post,
      required this.postComment,
      required this.postLike,
      required this.image,
      required this.text});

  static fromJson(Map data) {
    String image = data['user_image'] ?? "/media/image/notfound.jpg";
    String text = data['text'] ?? "(Empty)";
    int post = data['post'] ?? 0;
    int postLike = data['post_like'] ?? 0;
    int postComment = data['post_comment'] ?? 0;
    return NotificationsModel(
        post: post,
        postComment: postComment,
        postLike: postLike,
        image: image,
        text: text);
  }

  Future<List<NotificationsModel>> getNotificationsList(
      {required int page}) async {
    try {
      Map data = await requestIfPossible(
        url: '/notifications/',
        requestMethod: 'GET',
        expectedCode: 200,
      );
      if (data['notifications'].length==0){
        this.moreAvailable=false;
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
