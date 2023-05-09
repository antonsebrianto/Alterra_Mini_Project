import 'dart:convert';

import 'package:blog_app/constants.dart';
import 'package:blog_app/model/models/api_response.dart';
import 'package:blog_app/model/models/comment.dart';
import 'package:blog_app/model/services/user_service.dart';
import 'package:http/http.dart' as http;

class CommentAPI {
  final userAPI = UserAPI();
  // GET POST COMMENTS
  Future<ApiResponse> getPostComments(int postId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      String token = await userAPI.getToken();
      final response = await http.get(Uri.parse('$postUrl/$postId/comments'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });

      switch (response.statusCode) {
        case 200:
          // MAP EACH COMMENTS TO COMMENT MODEL
          apiResponse.data = jsonDecode(response.body)['comments']
              .map((p) => Comment.fromJson(p))
              .toList();
          apiResponse.data as List<dynamic>;
          break;
        case 403:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

// CREATE COMMENT
  Future<ApiResponse> createPostComment(int postId, String? comment) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      String token = await userAPI.getToken();
      final response = await http.post(Uri.parse('$postUrl/$postId/comments'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: {
            'comment': comment
          });

      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body);
          break;
        case 403:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

// DELETE COMMENT
  Future<ApiResponse> deletePostComment(int commentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      String token = await userAPI.getToken();
      final response = await http.delete(Uri.parse('$commentsUrl/$commentId'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });

      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body)['message'];
          break;
        case 403:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

// EDIT COMMENT
  Future<ApiResponse> updatePostComment(int commentId, String comment) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      String token = await userAPI.getToken();
      final response = await http.put(Uri.parse('$commentsUrl/$commentId'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: {
            'comment': comment
          });

      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body)['message'];
          break;
        case 403:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }
}
