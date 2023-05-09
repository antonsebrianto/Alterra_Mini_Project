import 'dart:convert';

import 'package:blog_app/constants.dart';
import 'package:blog_app/model/models/api_response.dart';
import 'package:blog_app/model/models/post.dart';
import 'package:blog_app/model/services/user_service.dart';
import 'package:http/http.dart' as http;

class PostAPI {
  final userAPI = UserAPI();
  // GET ALL POST
  Future<ApiResponse> getPosts() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      String token = await userAPI.getToken();
      final response = await http.get(Uri.parse(postUrl), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      // print(response.statusCode.toString());
      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body)['posts']
              .map((p) => Post.fromJson(p))
              .toList();
          // MAP EACH ITEM TO POST MODEL
          apiResponse.data as List<dynamic>;
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

   // GET ALL POST BY POPULAR
  Future<ApiResponse> getPostsPopular() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      String token = await userAPI.getToken();
      final response = await http.get(Uri.parse(postPopularUrl), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      // print(response.statusCode.toString());
      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body)['posts']
              .map((p) => Post.fromJson(p))
              .toList();
          // MAP EACH ITEM TO POST MODEL
          apiResponse.data as List<dynamic>;
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

  // GET ALL POST BY POPULAR
  Future<ApiResponse> getSinglePost(int postId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      String token = await userAPI.getToken();
      final response = await http.get(Uri.parse('$postUrl/$postId'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      // print(response.statusCode.toString());
      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body)['post']
              .map((p) => Post.fromJson(p))
              .toList();
          // MAP EACH ITEM TO POST MODEL
          apiResponse.data as List<dynamic>;
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

// CREATE POST
  Future<ApiResponse> createPost(
      String title, String subtitle, String body, String? image) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      String token = await userAPI.getToken();
      final response = await http.post(Uri.parse(postUrl),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: image != null
              ? {
                  'title': title,
                  'subtitle': subtitle,
                  'body': body,
                  'image': image,
                }
              : {
                  'body': body,
                });

      // IF IMAGE IS NULL JUST SEND THE BODY, IF IMAGE NOT NULL SEND THE IMAGE AND BODY
      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body);
          break;
        case 422:
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
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

// UPDATE POST
  Future<ApiResponse> updatePost(
      int postId, String title, String subtitle, String body) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      String token = await userAPI.getToken();
      final response = await http.put(Uri.parse('$postUrl/$postId'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }, body: {
        'title': title,
        'subtitle': subtitle,
        'body': body
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

// DELETE POST
  Future<ApiResponse> deletePost(int postId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      String token = await userAPI.getToken();
      final response =
          await http.delete(Uri.parse('$postUrl/$postId'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
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

// LIKE OR UNLIKE POST
  Future<ApiResponse> likeOrUnlikePost(int postId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      String token = await userAPI.getToken();
      final response =
          await http.post(Uri.parse('$postUrl/$postId/likes'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body)['message'];
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
