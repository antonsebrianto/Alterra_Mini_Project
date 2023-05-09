import 'package:blog_app/view/pages/login_page.dart';
import 'package:blog_app/view/pages/update_profile_page.dart';
import 'package:blog_app/view/widgets/profile_menu_widget.dart';
import 'package:blog_app/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void userLogout() async {
    if (await context.read<UserViewModel>().userLogout()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Logout successfull')));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Logout failed')));
    }
  }

  @override
  void initState() {
    context.read<UserViewModel>().getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return context.read<UserViewModel>().loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: Consumer<UserViewModel>(
              builder: (context, value, child) => SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                          width: 120,
                          height: 120,
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: value.user.image == null
                                ? const NetworkImage(
                                    'https://upload.wikimedia.org/wikipedia/commons/3/34/PICA.jpg')
                                : NetworkImage(value.user.image ?? ''),
                            backgroundColor: Colors.transparent,
                          )),
                      const SizedBox(height: 10),
                      Text(value.user.name.toString(),
                          style: Theme.of(context).textTheme.headline4),
                      Text(value.user.email.toString(),
                          style: Theme.of(context).textTheme.bodyText2),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UpdateProfilePage()));
                          },
                          style: ElevatedButton.styleFrom(
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: const Text('Edit Profile',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 10),
                      ProfileMenuWidget(
                          title: "Logout",
                          icon: LineAwesomeIcons.alternate_sign_out,
                          textColor: Colors.red,
                          endIcon: false,
                          onPress: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Logout'),
                                    content: const Text(
                                        'Are you sure want to logout?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          userLogout();
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Confirm'),
                                      ),
                                    ],
                                  );
                                });
                          }),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
