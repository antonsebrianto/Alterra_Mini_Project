import 'dart:io';

import 'package:blog_app/constants.dart';
import 'package:blog_app/model/models/api_response.dart';
import 'package:blog_app/model/models/user.dart';
import 'package:blog_app/model/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {
  final UserAPI userAPI = UserAPI();
  User user = User();
  bool loading = false;
  File? fileImage;
  final _picker = ImagePicker();
  String? token;
  ApiResponse apiResponse = ApiResponse();

  // GET IMAGE
  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      fileImage = File(pickedFile.path);
      notifyListeners();
    }
    notifyListeners();
  }

  // GET USER DETAIL
  Future<void> getUser() async {
    apiResponse = await userAPI.getUserDetail();
    if (apiResponse.error == null) {
      user = apiResponse.data as User;
      loading = loading ? !loading : loading;
      notifyListeners();
    }
    notifyListeners();
  }

  // UPDATE PROFILE
  Future<bool> updateProfile(String name) async {
    String? currentImage;
    if (fileImage == null) {
      currentImage = await userAPI.networkImageToBase64(user.image!);
    } else {
      currentImage = userAPI.getStringImage(fileImage);
    }
    apiResponse = await userAPI.updateUser(name, currentImage);
    if (apiResponse.error == null) {
      fileImage = null;
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  Future<bool> userLogin(String email, String password) async {
    apiResponse = await userAPI.login(email, password);
    if (apiResponse.error == null) {
      loading = loading ? !loading : loading;
      saveAndRedirectToHome(apiResponse.data as User);
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  Future<bool> userRegister(String name, String email, String password) async {
    apiResponse = await userAPI.register(name, email, password);
    if (apiResponse.error == null) {
      loading = loading ? !loading : loading;
      saveAndRedirectToHome(apiResponse.data as User);
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  void saveAndRedirectToHome(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('token', user.token ?? '');
    await sharedPreferences.setInt('userId', user.id ?? 0);
    notifyListeners();
  }

  Future<bool> loadUserInfo() async {
    token = await userAPI.getToken();
    if (token == '' || apiResponse.error == unauthorized) {
      userLogout();
      notifyListeners();
      return false;
    } else {
      apiResponse = await userAPI.getUserDetail();
      notifyListeners();
      return true;
    }
  }

  Future<bool> userLogout() async {
    try {
      userAPI.logout();
      notifyListeners();
      return true;
    } catch (e) {
      notifyListeners();
      return false;
    }
  }
}
