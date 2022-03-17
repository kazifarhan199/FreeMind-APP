import 'package:hive/hive.dart';
import 'package:social/models/request.dart';
import 'package:social/models/users.dart';
import 'package:social/vars.dart';

class GroupModel{
  String name;
  int id;
  List<membersModel> members;

  GroupModel({required this.name, required this.id, required this.members});

  static GroupModel fromJson(Map data){
    String name = data['group_name'] ?? 'Group Name';
    int id = data['id'] ?? 0;
    List<membersModel> members = data['members']==null? [membersModel.fromJson({}), membersModel.fromJson({})] : data['members'].map(membersModel.fromJson).toList().cast<membersModel>();
    return GroupModel(name: name, id: id, members: members);
  }

  static Future<GroupModel> createNewGroup(String name) async {
    if (name=='' ? true : false){
      throw Exception(ErrorStrings.group_name_needed);
    }
    try {
      Map data =await requestIfPossible(
      url: '/groups/create/',
      requestMethod: 'POST',
      expectedCode: 201,
      body: {
          "group_name": name,
        },
      );
      User.addGroup(data['id']);
      return GroupModel.fromJson(data);
    } on Exception catch (e) {
      throw e;
    }
  }


  static Future<GroupModel> getGroup() async {
    try {
      Map data =await requestIfPossible(
        url: '/groups/',
        requestMethod: 'GET',
        expectedCode: 200,
      );
      User.addGroup(data['id']);
      return GroupModel.fromJson(data);
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<List<membersModel>> addMember({required String email}) async {
    if (email=='' ? true : false){
      throw Exception(ErrorStrings.email_needed);
    }
    try {
      Map data = await requestIfPossible(
          url: '/groups/members/',
          body: {
            'email': email,
          },
          requestMethod: 'POST',
          expectedCode: 201,
        );
      this.members+=[membersModel.fromJson({'email':email, 'username':email}), ];
      return this.members;
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<List<membersModel>> removeMember({required String email}) async {
    try {
      Map data = await requestIfPossible(
        url: '/groups/members/',
        body: {
          'email': email,
        },
        requestMethod: 'DELETE',
        expectedCode: 202,
      );

      User user = Hive.box('userBox').getAt(0) as User;
      if(email == user.email){
        User.addGroup(0);
      }
      
      this.members.removeWhere((element) => element.email==email);
      return this.members;
    } on Exception catch (e) {
      throw e;
    }
  }


  Future<bool> editGroup({required String name}) async {
    if (name=='' ? true : false){
      throw Exception(ErrorStrings.name_needed);
    }
    try {
      Map data = await requestIfPossible(
        url: '/groups/',
        body: {
          'group_name': name,
        },
        requestMethod: 'PUT',
        expectedCode: 202,
      );
      this.name = name;
      return true;
    } on Exception catch (e) {
      throw e;
    }
  }
  
}

class membersModel{
  String userName, userImage, email;
  membersModel({required this.userName, required this.email, required this.userImage});
  String get userImageUrl => base_url + userImage; 

  static membersModel fromJson(data){
    String email = data['email'] ?? "email";
    String userName = data['username'] ?? "username";
    String userImage = data['userimage'] ?? data['userimage'] ?? "/media/image/notfound.jpg";
    return membersModel(userName: userName, email: email, userImage: userImage);
  }
}