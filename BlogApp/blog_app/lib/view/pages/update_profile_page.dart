import 'dart:io';

import 'package:blog_app/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    context.read<UserViewModel>().getUser();
    context.read<UserViewModel>().fileImage = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
      ),
      body: Consumer<UserViewModel>(
        builder: (context, value, child) => SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                        width: 120,
                        height: 120,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: context
                                      .read<UserViewModel>()
                                      .fileImage ==
                                  null
                              ? value.user.image != null
                                  ? NetworkImage(value.user.image ?? '')
                                  : const NetworkImage(
                                      'https://upload.wikimedia.org/wikipedia/commons/3/34/PICA.jpg')
                              : FileImage(
                                  context.read<UserViewModel>().fileImage ??
                                      File('')) as ImageProvider,
                          backgroundColor: Colors.transparent,
                        )),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.orange),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 23),
                          onPressed: () async {
                            await context.read<UserViewModel>().getImage();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Form(
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                              label: Text(value.user.name.toString()),
                              prefixIcon: const Icon(LineAwesomeIcons.user)),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_nameController.text.isEmpty) {
                                await context
                                    .read<UserViewModel>()
                                    .updateProfile(context
                                        .read<UserViewModel>()
                                        .user
                                        .name
                                        .toString());
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Profile update successful')));
                                  context.read<UserViewModel>().getUser();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Profile update failed')));
                                }
                              } else {
                                await context
                                    .read<UserViewModel>()
                                    .updateProfile(_nameController.text);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Profile update successful')));
                                  context.read<UserViewModel>().getUser();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Profile update failed')));
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: const Text('Submit',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
