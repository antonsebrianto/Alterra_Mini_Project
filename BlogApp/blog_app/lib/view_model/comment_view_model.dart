import 'package:blog_app/model/models/api_response.dart';
import 'package:blog_app/model/services/comment_service.dart';
import 'package:blog_app/model/services/user_service.dart';
import 'package:flutter/cupertino.dart';

class CommentViewModel with ChangeNotifier {
  final commentAPI = CommentAPI();
  final userAPI = UserAPI();
  List<dynamic> listComments = [];
  int userId = 0;
  bool loading = true;
  // GET COMMENTS
  Future<void> getComments(int postId) async {
    userId = await userAPI.getUserId();
    ApiResponse apiResponse = await commentAPI.getPostComments(postId);

    if (apiResponse.error == null) {
      listComments = apiResponse.data as List<dynamic>;
      notifyListeners();
    }
    notifyListeners();
  }

  // CREATE COMMENT
  Future<void> createComment(int postId, String comment) async {
    ApiResponse apiResponse =
        await commentAPI.createPostComment(postId, comment);
    if (apiResponse.error == null) {
      getComments(postId);
      notifyListeners();
    }
    notifyListeners();
  }

  // DELETE COMMENT
  void deleteComment(int postId, int commentId) async {
    ApiResponse apiResponse = await commentAPI.deletePostComment(commentId);
    if (apiResponse.error == null) {
      getComments(postId);
      notifyListeners();
    }
    notifyListeners();
  }

  // EDIT COMMENT
  void editComment(int postId, int editCommentId, String comment) async {
    ApiResponse apiResponse =
        await commentAPI.updatePostComment(editCommentId, comment);
    if (apiResponse.error == null) {
      getComments(postId);
      notifyListeners();
    }
    notifyListeners();
  }
}
