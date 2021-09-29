import 'package:flutter/material.dart';
import 'package:social/models/posts.dart';

class PostListModel extends ChangeNotifier {
  String error = '';
  List<PostModel> posts = [];
  PostModel post_caller = PostModel({});

  Map<int, PostModel> postMap = {};

  get length => postMap.length;

  get next => post_caller.next;

  get values => postMap.values.toList();

  get hasError => error == '' ? false : true;

  Future<List<PostModel>> getPostList({newPage = 0}) async {
    return await post_caller.getPostList(newPage: newPage);
  }

  Future<bool> getPosts() async {
    List<PostModel> tmp_p = await post_caller.getPostList();
    if (post_caller.hasError) {
      error = post_caller.error;
      return false;
    } else {
      posts.addAll(tmp_p);
      notifyListeners();
      return true;
    }
  }

  addAll(Map<int, PostModel> newPosts) {
    postMap.addAll(newPosts);
    notifyListeners();
  }

  add(PostModel newPost) {
    postMap[newPost.id] = newPost;
    notifyListeners();
  }

  changeLikeStatus(int id) async {
    if (this.postMap[id]!.liked) {
      removeLike(id);
    } else {
      addLike(id);
    }
    notifyListeners();
  }

  addLike(int id) async {
    this.postMap[id]!.likes++;
    this.postMap[id]!.liked = true;
    notifyListeners();
    bool success = await this.postMap[id]!.likesAdd();
    if (success) {
    } else {
      notifyListeners();
    }
  }

  removeLike(int id) async {
    this.postMap[id]!.likes--;
    this.postMap[id]!.liked = false;
    notifyListeners();
    bool success = await this.postMap[id]!.likesRemove();
    if (success) {
    } else {
      notifyListeners();
    }
  }

  addComment(int id, String text) async {
    await this.postMap[id]!.commentsAdd(text);
    notifyListeners();
  }

  removeComment(int id, int commentID) {
    this.postMap[id]!.commentsRemove(commentID);
    notifyListeners();
  }

  Future<bool> deletePost(int id, {bool silent = false}) async {
    bool success = await this.postMap[id]!.deletePost();
    if (success) {
      this.postMap.remove(id);
      if (!silent) notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
