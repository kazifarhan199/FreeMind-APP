import 'package:hive/hive.dart';
import 'package:social/models/request.dart';
import 'package:social/models/users.dart';
import 'package:social/vars.dart';

class GroupModel{
  String name;
  int id;
  bool isin;
  List<membersModel> members;

  GroupModel({required this.name, required this.id, required this.members, required this.isin});

  static GroupModel fromJson(Map data){
    print(data);
    String name = data['group_name'] ?? 'Group Name';
    int id = data['id'] ?? 0;
    List<membersModel> members = data['members']==null? [] : data['members'].map(membersModel.fromJson).toList().cast<membersModel>();
    bool isin = data['isin'] ?? true;
    return GroupModel(name: name, id: id, members: members, isin: isin);
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


  static Future<List<GroupModel>> getgChannels() async {
    try {
      Map data =await requestIfPossible(
        url: '/groups/gchannel/',
        requestMethod: 'GET',
        expectedCode: 200,
      );
        List<GroupModel> localComments =  data['results']
          .map((d) => GroupModel.fromJson(d))
          .toList()
          .cast<GroupModel>();
      return localComments;
    } on Exception catch (e) {
      throw e;
    }
  }

  static Future<List<GroupModel>> getGroups() async {
    try {
      Map data =await requestIfPossible(
        url: '/groups/list/',
        requestMethod: 'GET',
        expectedCode: 200,
      );
        List<GroupModel> localComments =  data['results']
          .map((d) => GroupModel.fromJson(d))
          .toList()
          .cast<GroupModel>();
      return localComments;
    } on Exception catch (e) {
      throw e;
    }
  }

  static Future<GroupModel> getGroup({required int gid}) async {
    try {
      Map data =await requestIfPossible(
        url: '/groups/?group='+gid.toString(),
        requestMethod: 'GET',
        expectedCode: 200,
      );
      User.addGroup(data['id']);
      return GroupModel.fromJson(data);
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<List<membersModel>> addMember({required String email, bool channel=false, required int group, required int gid}) async {
    if (email=='' ? true : false){
      throw Exception(ErrorStrings.email_needed);
    }
    String url = '/groups/members/?group='+gid.toString();
    if (channel){
      url = '/groups/gchannel/';
    }
    try {
      Map data = await requestIfPossible(
          url: url,
          body: {
            'email': email,
            'group':group.toString(),
          },
          requestMethod: 'POST',
          expectedCode: 201,
        );
      if (!channel){
        this.members+=[membersModel.fromJson({'email':email, 'username':email}), ];
      }
      return this.members;
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<List<membersModel>> removeMember({required String email, bool channel=false, required int group, required int gid}) async {
    if (email=='' ? true : false){
      throw Exception(ErrorStrings.email_needed);
    }
    
    String url = '/groups/members/?group='+gid.toString();
    if (channel){
      url = '/groups/gchannel/';
    }

    try {
      Map data = await requestIfPossible(
        url: url,
        body: {
          'email': email,
          'group': group.toString(),
        },
        requestMethod: 'DELETE',
        expectedCode: 202,
      );

      if (!channel){
        User user = Hive.box('userBox').getAt(0) as User;
        if(email == user.email){
          User.addGroup(0);
        }
        this.members.removeWhere((element) => element.email==email);
      }
      return this.members;
    } on Exception catch (e) {
      throw e;
    }
  }


  Future<bool> editGroup({required String name, required int gid}) async {
    if (name=='' ? true : false){
      throw Exception(ErrorStrings.name_needed);
    }
    try {
      Map data = await requestIfPossible(
        url: '/groups/?group='+gid.toString(),
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