import 'package:social/utils/staticStrings.dart';

class Member {
  String email = '', userName = '', userImage = '';

  Member(data) {
    this.email = data['email'] ?? "";
    this.userName = data['username'] ?? "";
    this.userImage = data['userimage'] ?? data['image'] ?? "";
  }

  get userImageURL => StaticStrings.base_url + this.userImage;
}
