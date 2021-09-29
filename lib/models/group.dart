class GroupModel {
  String name = '';
  List<MemberModel> members = [];

  GroupModel({Map data = const {}}) {
    if (data != {}) {}
  }
}

class MemberModel {
  String userName = '', userImage = '', email = '';
}
