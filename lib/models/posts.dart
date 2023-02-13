import 'dart:io';
import 'package:http/http.dart';
import 'package:social/vars.dart';
import 'package:social/models/request.dart';

class PostModel {
  String userName, userImage, title, image;
  int likes, comments, id, uid, group;
  bool owner, liked, moreAvailable = true;
  String get userImageUrl => base_url + userImage;
  String get imageUrl => base_url + image;
  List<CommentModel> commentsList = [];
  List<LikeModel> likesList = [];
  String groupName, groupImage, link;
  Map data = {};
  DateTime datetime;
  bool isRecommendation;

  PostModel({
    required this.userName,
    required this.userImage,
    required this.title,
    required this.image,
    required this.likes,
    required this.comments,
    required this.owner,
    required this.liked,
    required this.id,
    required this.uid,
    required this.groupName,
    required this.groupImage,
    required this.group,
    required this.link,
    required this.datetime,
    required this.isRecommendation,
  });

  Map getPreviousRawData() {
    return data;
  }

  static PostModel fromJson(data) {
    String userName = data['username'] ?? 'User Name :)';
    String userImage = data['user_image'] ?? '/media/image/notfound.jpg';
    String title = data['title'] ?? 'This is title';
    String image = '/media/image/notfound.jpg';
    if (data['images'] != null) {
      if (data['images'].isNotEmpty) {
        image = data['images'][0]['image_url'] ?? '/media/image/notfound.jpg';
      }
    }
    int likes = data['like_count'] ?? 0;
    int comments = data['comment_count'] ?? 0;
    int id = data['id'] ?? 0;
    bool owner = data['owner'] ?? false;
    bool liked = data['liked'] ?? false;
    int uid = data['uid'] ?? 0;
    String groupName = data['group_name'] ?? '';
    String groupImage = data['group_image'] ?? '';
    int group = data['group'] ?? 0;
    String link = data['link'] ?? '';
    String datetimeString = data['created_on'] ?? '1969-07-20 20:18:04Z';
    DateTime datetime = DateTime.parse(datetimeString);
    bool isRecommendation = data['is_recommendation'] ?? false;
    return PostModel(
        userName: userName,
        userImage: userImage,
        title: title,
        image: image,
        likes: likes,
        comments: comments,
        owner: owner,
        liked: liked,
        id: id,
        uid: uid,
        groupImage: groupImage,
        groupName: groupName,
        group: group,
        link: link,
        datetime: datetime,
        isRecommendation: isRecommendation);
  }

  String get groupImageUrl => base_url + this.groupImage;

  Future<PostModel> createPost(
      {required String title,
      required File image,
      required int group,
      required String link}) async {
    if (title == '' ? true : false) {
      throw Exception(ErrorStrings.title_needed);
    }
    print(group);
    try {
      Iterable<MultipartFile> file = image == null
          ? []
          : [
              await MultipartFile.fromPath(
                'images',
                image.path,
              )
            ];
      data = await requestIfPossible(
        url: '/posts/create/',
        requestMethod: 'POST',
        expectedCode: 201,
        files: file,
        body: {
          "title": title,
          'group': group.toString(),
          'link': link,
        },
      );
      return PostModel.fromJson(data);
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<PostModel> getPost({required int id}) async {
    try {
      data = await requestIfPossible(
        url: '/posts/detail/?post=' + id.toString(),
        requestMethod: 'GET',
        expectedCode: 200,
      );
      return PostModel.fromJson(data);
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<List<PostModel>> getPostList({required int page}) async {
    try {
      data = await requestIfPossible(
        url: '/posts/?page=' + page.toString(),
        requestMethod: 'GET',
        expectedCode: 200,
      );
      if (data['results'].length == 0) {
        this.moreAvailable = false;
        return [];
      }
      if (data['next'] == null) {
        this.moreAvailable = false;
      }

      return data['results']
          .map((d) => PostModel.fromJson(d))
          .toList()
          .cast<PostModel>();
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<List<PostModel>> getProfilePostList(
      {required int page, required int uid}) async {
    try {
      data = await requestIfPossible(
        url: '/posts/profile/?page=' +
            page.toString() +
            "&user=" +
            uid.toString(),
        requestMethod: 'GET',
        expectedCode: 200,
      );
      if (data['results'].length == 0) {
        this.moreAvailable = false;
        return [];
      }
      if (data['next'] == null) {
        this.moreAvailable = false;
      }

      return data['results']
          .map((d) => PostModel.fromJson(d))
          .toList()
          .cast<PostModel>();
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<List<LikeModel>> getLikeList() async {
    try {
      data = await requestIfPossible(
        url: '/posts/likes/?post=' + this.id.toString(),
        requestMethod: 'GET',
        expectedCode: 200,
      );
      if (data['results'].length == 0) {
        return [];
      }

      return data['results']
          .map((d) => LikeModel.fromJson(d))
          .toList()
          .cast<LikeModel>();
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<LikeModel> addLike() async {
    try {
      data = await requestIfPossible(
        url: '/posts/likes/detail/',
        requestMethod: 'POST',
        body: {'post': this.id.toString()},
        expectedCode: 201,
      );
      this.liked = true;
      this.likes += 1;
      return LikeModel.fromJson(data);
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<LikeModel> removeLike() async {
    try {
      data = await requestIfPossible(
        url: '/posts/likes/detail/',
        requestMethod: 'DELETE',
        body: {'post': this.id.toString()},
        expectedCode: 202,
      );
      this.liked = false;
      this.likes -= 1;
      return LikeModel.fromJson(data);
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<List<CommentModel>> getCommentList() async {
    try {
      data = await requestIfPossible(
        url: '/posts/comments/?post=' + this.id.toString(),
        requestMethod: 'GET',
        expectedCode: 200,
      );
      if (data['results'].length == 0) {
        return [];
      }

      List<CommentModel> localComments = data['results']
          .map((d) => CommentModel.fromJson(d))
          .toList()
          .cast<CommentModel>();
      this.commentsList = localComments;
      this.comments = this.commentsList.length;
      return localComments;
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<CommentModel> addComment(String text) async {
    try {
      data = await requestIfPossible(
        url: '/posts/comments/detail/',
        requestMethod: 'POST',
        body: {'post': this.id.toString(), 'text': text},
        expectedCode: 201,
      );
      CommentModel comment = CommentModel.fromJson(data);
      this.commentsList += [comment];
      this.comments = this.commentsList.length;
      return comment;
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<bool> removeComment(int id) async {
    try {
      data = await requestIfPossible(
        url: '/posts/comments/detail/',
        requestMethod: 'DELETE',
        body: {'post': this.id.toString(), 'comment': id.toString()},
        expectedCode: 202,
      );
      this.commentsList.removeWhere((value) => value.id == id);
      this.comments = this.commentsList.length;
      return true;
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<bool> deletePost() async {
    try {
      data = await requestIfPossible(
        url: '/posts/delete/',
        requestMethod: 'DELETE',
        body: {'post': this.id.toString()},
        expectedCode: 202,
      );
      return true;
    } catch (e) {
      throw e;
    }
  }
}

class CommentModel {
  String userName = '', userImage = '', text = '';
  int id = 0;
  bool needFeedback;
  String get userImageUrl => base_url + this.userImage;
  String link;
  get hasLink => link == '' ? false : true;
  DateTime datetime;

  CommentModel({
    required this.userName,
    required this.userImage,
    required this.text,
    required this.id,
    required this.needFeedback,
    required this.link,
    required this.datetime,
  });

  static CommentModel fromJson(data) {
    String userName = data['username'] ?? 'User Name';
    String userImage = data['userimage'] ?? '/media/image/notfound.jpg';
    String text = data['text'] ?? 'this is text';
    int id = data['id'] ?? 0;
    bool needFeedback = data['need_feadback'] ?? false;
    String datetimeString = data['created_on'] ?? '1969-07-20 20:18:04Z';
    DateTime datetime = DateTime.parse(datetimeString);
    String link = data['link'] ?? '';
    return CommentModel(
        userName: userName,
        userImage: userImage,
        text: text,
        id: id,
        datetime: datetime,
        needFeedback: needFeedback,
        link: link);
  }

  sendfeedback({required FeedbackModel feeback}) async {
    try {
      Map data = await requestIfPossible(
        url: '/posts/feedback/',
        requestMethod: 'POST',
        body: {
          'comment': this.id.toString(),
          'text': feeback.text,
          'rating': feeback.rating.toString()
        },
        expectedCode: 201,
      );
      this.needFeedback = false;
    } catch (e) {
      throw e;
    }
  }
}

class LikeModel {
  String userName = '', userImage = '';
  int id = 0;
  String get userImageUrl => base_url + this.userImage;

  LikeModel(
      {required this.userName, required this.userImage, required this.id});

  static LikeModel fromJson(data) {
    String userName = data['username'] ?? 'User Name';
    String userImage = data['userimage'] ?? '/media/image/notfound.jpg';
    int id = data['id'] ?? 0;
    return LikeModel(userName: userName, userImage: userImage, id: id);
  }
}

class FeedbackModel {
  String text;
  int rating;

  FeedbackModel({required this.rating, required this.text});

  static FeedbackModel fromJson(data) {
    int rating = data['rating'] ?? 0;
    String text = data['text'] ?? '';
    return FeedbackModel(rating: rating, text: text);
  }
}
