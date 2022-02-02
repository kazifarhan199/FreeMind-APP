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
    error = "";
    return await post_caller.getPostList(newPage: newPage);
  }

  Future<bool> getPosts() async {
    error = "";
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
    error = "";
    postMap.addAll(newPosts);
    notifyListeners();
  }

  add(PostModel newPost) {
    error = "";
    postMap[newPost.id] = newPost;
    notifyListeners();
  }

  Future<bool> changeLikeStatus(int id) async {
    print("main root");
    print(this.error);

    error = "";
    if (this.postMap[id]!.liked) {
      await removeLike(id);
    } else {
      await addLike(id);
    }
    notifyListeners();
    print("Root");
    print(this.error);
    if (this.hasError)
      return false;
    else 
      return true;
  }

  addLike(int id) async {
    bool success = await this.postMap[id]!.likesAdd();
    if (success) {
    } else {
      if (this.postMap[id]!.hasError)
        this.error = this.postMap[id]!.error;
      else
        this.error = "Some error occured";
    }
    print(this.error);
    notifyListeners();
  }

  removeLike(int id) async {
    bool success = await this.postMap[id]!.likesRemove();
    if (success) {
    } else {
      if (this.postMap[id]!.hasError)
        this.error = this.postMap[id]!.error;
      else
        this.error = "Some error occured";
    }
    print(this.error);
    notifyListeners();
  }

  addComment(int id, String text) async {
    error = "";
    await this.postMap[id]!.commentsAdd(text);
    notifyListeners();
  }

  removeComment(int id, int commentID) {
    error = "";
    this.postMap[id]!.commentsRemove(commentID);
    notifyListeners();
  }

  Future<bool> deletePost(int id, {bool silent = false}) async {
    error = "";
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
