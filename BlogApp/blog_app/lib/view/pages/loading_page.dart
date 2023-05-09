import 'package:blog_app/constants.dart';
import 'package:blog_app/model/models/api_response.dart';
import 'package:blog_app/view/pages/dashboard_page.dart';
import 'package:blog_app/view/pages/login_page.dart';
import 'package:blog_app/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  void _loadUserInfo() async{
    if (await context.read<UserViewModel>().loadUserInfo()) {
      ApiResponse apiResponse = context.read<UserViewModel>().apiResponse;
      if (apiResponse.error == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const DashboardPage()),
            (route) => false);
      } else if (apiResponse.error == unauthorized) {
        context.read<UserViewModel>().userLogout();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${apiResponse.error}')));
      }
    } else{
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    }
  }

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
