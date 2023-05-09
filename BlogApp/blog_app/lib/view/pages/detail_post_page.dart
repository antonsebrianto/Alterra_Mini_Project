import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:blog_app/model/models/post.dart';
import 'package:blog_app/view/widgets/bottom_sheet_content.dart';
import 'package:blog_app/view/widgets/top_sheet_content.dart';
import 'package:blog_app/view_model/post_view_model.dart';

class DetailPostPage extends StatelessWidget {
  final Post? post;
  final int index;
  final bool isPopuler;

  const DetailPostPage({
    Key? key,
    this.post,
    required this.index,
    this.isPopuler = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var isPressed = true;
    context.read<PostViewModel>().retrieveSinglePost(post!.id ?? 0);
    context.read<PostViewModel>().retrievePosts();
    context.read<PostViewModel>().retrievePostsPopular();
    
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Consumer<PostViewModel>(
          builder: ((context, value, child) => Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  TopSheetContent(
                      height: height, post: post!, isPressed: isPressed),
                  Container(
                    margin: EdgeInsets.only(top: height / 2.3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                    ),
                    child: Consumer<PostViewModel>(
                      builder: (context, value, child) => BottomSheetContent(
                          height: height,
                          width: width,
                          post: isPopuler
                              ? value.postsPopular[index]
                              : value.posts[index]),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
