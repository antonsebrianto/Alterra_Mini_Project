import 'dart:io';

import 'package:blog_app/model/models/api_response.dart';
import 'package:blog_app/model/services/post_service.dart';
import 'package:blog_app/model/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class PostViewModel with ChangeNotifier {
  final PostAPI postAPI = PostAPI();
  final UserAPI userAPI = UserAPI();
  int userId = 0;
  List<dynamic> _posts = [];
  List<dynamic> get posts => _posts;
  List<dynamic> _postsPopular = [];
  List<dynamic> get postsPopular => _postsPopular;
  File? fileImage;
  final _picker = ImagePicker();
  bool loading = false;

  // GET ALL POSTS
  Future<void> retrievePosts() async {
    userId = await userAPI.getUserId();
    final ApiResponse apiResponse = await postAPI.getPosts();
    if (apiResponse.error == null) {
      _posts = apiResponse.data as List<dynamic>;
      loading = loading ? !loading : loading;
      notifyListeners();
    }
    notifyListeners();
  }

  // GET ALL POSTS POPULAR
  Future<void> retrievePostsPopular() async {
    userId = await userAPI.getUserId();
    ApiResponse apiResponse = await postAPI.getPostsPopular();
    if (apiResponse.error == null) {
      _postsPopular = apiResponse.data as List<dynamic>;
      loading = loading ? !loading : loading;
      notifyListeners();
    }
    notifyListeners();
  }

  // GET ALL POSTS POPULAR
  Future<void> retrieveSinglePost(int postId) async {
    userId = await userAPI.getUserId();
    ApiResponse apiResponse = await postAPI.getSinglePost(postId);
    if (apiResponse.error == null) {
      _posts = apiResponse.data as List<dynamic>;
      loading = loading ? !loading : loading;
      notifyListeners();
    }
    notifyListeners();
  }

  // DELETE POST
  void handleDeletePost(int postId) async {
    ApiResponse apiResponse = await postAPI.deletePost(postId);
    if (apiResponse.error == null) {
      retrievePosts();
      retrievePostsPopular();
      notifyListeners();
    }
    notifyListeners();
  }

  // GET IMAGE
  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      fileImage = File(pickedFile.path);
      notifyListeners();
    }
    notifyListeners();
  }

  // CREATE POST
  Future<bool> createPost(String title, String subtitle, String body) async {
    String? image =
        fileImage == null ? null : userAPI.getStringImage(fileImage);
    ApiResponse apiResponse =
        await postAPI.createPost(title, subtitle, body, image);

    if (apiResponse.error == null) {
      loading = true;
      fileImage = null;
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  // EDIT POST
  Future<bool> editPost(
      int postId, String title, String subtitle, String body) async {
    ApiResponse apiResponse =
        await postAPI.updatePost(postId, title, subtitle, body);
    if (apiResponse.error == null) {
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  // LIKE OR DISLIKE POST
  void handlePostLikeOrUnlike(int postId) async {
    ApiResponse response = await postAPI.likeOrUnlikePost(postId);

    if (response.error == null) {
      retrievePosts();
      retrievePostsPopular();
      retrieveSinglePost(postId);
      notifyListeners();
    }
    notifyListeners();
  }
}
