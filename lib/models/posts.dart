import 'dart:io';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:social/utils/network.dart';
import 'package:social/utils/staticStrings.dart';

class PostModel extends ChangeNotifier {
  String userName = '', userImage = '';
  String title = '', image = '', dateTime = '';
  int likes = 0, comments = 0, id = 0;
  bool liked = false;
  int page = 1;
  String next = "initial text";
  String error = '';
  InternalNetwork network = InternalNetwork();
  Map data = {};
  bool get hasError => this.error == '' ? false : true;

  get imageURL => this.image != null ? StaticStrings.base_url + this.image : "";
  get userImageURL =>
      this.userImage != null ? StaticStrings.base_url + this.userImage : "";

  PostModel(Map data) {
    if (data.isNotEmpty) {
      try {
        image = data['images'][0]['image_url'] ?? "";
      } catch (e) {
        print(e.toString());
        image = "";
      }
      id = data['id'] ?? 0;
      title = data['title'] ?? "";
      likes = data['like_count'] ?? 0;
      comments = data['comment_count'] ?? 0;
      dateTime = data['datetime'] ?? '';
      userName = data['username'] ?? '';
      userImage = data['user_image'] ?? '';
      liked = data['liked'] ?? false;
    }
  }

  changeLikeStatus() async {
    if (this.liked) {
      await likesRemove();
    } else {
      await likesAdd();
    }
    notifyListeners();
  }

  Future<List<PostModel>> getPostList({int newPage: 0}) async {
    List<PostModel> posts = [];
    error = '';

    if (newPage != 0) {
      page = newPage;
    }
    if (this.next == "" && newPage == 0) {
      return [];
    }

    // await Future.delayed(Duration(seconds: 3));
    data = await network.requestIfPossible(
      url: '/posts/?page=' + page.toString(),
      requestMethod: 'GET',
      expectedCode: 200,
    );
    if (network.hasError) {
      error = network.error;
      return [];
    } else {
      page++;
      this.next = data['next'] ?? "";
      List results = data['results'];
      for (var r in results) {
        posts.add(PostModel(r));
      }

      return posts;
    }
  }

  Future<PostModel> getPost() async {
    await Future.delayed(Duration(seconds: 3));
    // get page using page
    return PostModel(data);
  }

  Future<bool> createPost(String title, File? image) async {
    if (title == '') {
      error = "Title is required";
      return false;
    }
    if (image == null) {
      error = "Image is required";
      return false;
    }
    Iterable<MultipartFile> file = image == null
        ? []
        : [
            await MultipartFile.fromPath(
              'images',
              image.path,
            )
          ];

    data = await network.requestIfPossible(
      url: '/posts/create/',
      requestMethod: 'POST',
      expectedCode: 201,
      files: file,
      body: {
        "title": title,
      },
    );

    if (network.hasError) {
      error = network.error;
      return false;
    } else {
      return true;
    }
  }

  Future<bool> deletePost() async {
    data = await network.requestIfPossible(
      url: '/posts/delete/',
      requestMethod: 'DELETE',
      body: {'post': this.id.toString()},
      expectedCode: 202,
    );

    if (network.hasError) {
      error = network.error;
      return false;
    } else {
      notifyListeners();
      return true;
    }
  }

  Future<List<LikesModel>> likesList() async {
    data = await network.requestIfPossible(
      url: '/posts/likes/?post=' + this.id.toString(),
      requestMethod: 'GET',
      expectedCode: 200,
    );
    if (network.hasError) {
      error = network.error;
      return [];
    } else {
      List<LikesModel> likes = [];
      likes =
          data["results"].map((d) => LikesModel(d)).toList().cast<LikesModel>();
      notifyListeners();
      return likes;
    }
  }

  likeFromJson(Map data) {
    return LikesModel(data);
  }

  Future<bool> likesAdd() async {
    if (this.liked){return false;}
    data = await network.requestIfPossible(
      url: '/posts/likes/detail/',
      requestMethod: 'POST',
      body: {'post': this.id.toString()},
      expectedCode: 201,
    );

    if (network.hasError) {
      error = network.error;
      return false;
    } else {
      this.likes++;
      this.liked = true;
      notifyListeners();
      return true;
    }
  }

  Future<bool> likesRemove() async {
    if (!this.liked){return false;}

    data = await network.requestIfPossible(
      url: '/posts/likes/detail/',
      requestMethod: 'DELETE',
      body: {'post': this.id.toString()},
      expectedCode: 202,
    );

    if (network.hasError) {
      error = network.error;
      return false;
    } else {
      this.likes--;
      this.liked = false;
      notifyListeners();
      return true;
    }
  }

  Future<CommentsModel> commentsAdd(String text) async {
    data = await network.requestIfPossible(
      url: '/posts/comments/detail/',
      requestMethod: 'POST',
      body: {'post': this.id.toString(), 'text': text},
      expectedCode: 201,
    );

    if (network.hasError) {
      error = network.error;
      return CommentsModel({});
    } else {
      this.comments++;
      notifyListeners();
      return CommentsModel(data);
    }
  }

  Future<List<CommentsModel>> commentsList() async {
    error = "";
    data = await network.requestIfPossible(
      url: '/posts/comments/?post=' + this.id.toString(),
      requestMethod: 'GET',
      expectedCode: 200,
    );
    if (network.hasError) {
      error = network.error;
      return [];
    } else {
      List<CommentsModel> comments = [];
      comments = data["results"]
          .map((d) => CommentsModel(d))
          .toList()
          .cast<CommentsModel>();
      notifyListeners();
      return comments;
    }
  }

  Future<bool> commentsRemove(int commentID) async {
    if (commentID == 0) {
      error = "Comment is required";
      return false;
    }
    await Future.delayed(Duration(seconds: 3));
    this.comments--;
    notifyListeners();
    return true;
  }
}

class LikesModel {
  String userName = '', userImage = '';

  get userImageURL => StaticStrings.base_url + this.userImage;

  LikesModel(Map data) {
    userName = data['username'];
    userImage = data['userimage'];
  }
}

class CommentsModel {
  int id = 0;
  String userName = '', userImage = '', text = '', dateTime = '';

  get userImageURL => StaticStrings.base_url + this.userImage;

  CommentsModel(Map data) {
    userName = data['username'] ?? "";
    userImage = data['userimage'] ?? "";
    text = data['text'] ?? "";
    dateTime = data['created_on'] ?? "";
  }
}
