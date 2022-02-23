import 'package:social/utils/network.dart';
import 'package:social/utils/staticStrings.dart';

class NotificationsModel {
  String image = '', text = '';
  get imageURL => StaticStrings.base_url + this.image;

  NotificationsModel(Map data){
    this.image = data['user_image'] ?? "/media/image/notfound.jpg";
    this.text = data['text'] ?? "(Empty)";
  }
}


class NotificationsModelList {
  List<NotificationsModel> notifications = [];
  String error = "";
  Map data = {};
  get hasError =>  error == '' ? false : true;

  
  Future<bool> getNotifications() async {
    error = "";

    data = await network.requestIfPossible(
      url: '/notifications/',
      requestMethod: 'GET',
      expectedCode: 200,
    );
    if (await network.hasError) {
      error = network.error;
      return false;
    } else {
      notifications = data['notifications']
          .map((d) => NotificationsModel(d))
          .toList()
          .cast<NotificationsModel>();
      return true;
    }

  }  
}