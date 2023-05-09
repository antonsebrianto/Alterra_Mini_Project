import 'package:blog_app/view/pages/show_more_post_page.dart';
import 'package:blog_app/view/widgets/card_post.dart';
import 'package:blog_app/view/widgets/get_date.dart';
import 'package:blog_app/view/widgets/popular_post.dart';
import 'package:blog_app/view_model/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool selfLiked = true;

  @override
  void initState() {
    context.read<PostViewModel>().retrievePosts();
    context.read<PostViewModel>().retrievePostsPopular();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return context.read<PostViewModel>().loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: () {
              return context.read<PostViewModel>().retrievePosts();
            },
            child: SingleChildScrollView(
              child: Consumer<PostViewModel>(
                builder: (context, value, child) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.only(top: 70),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const GetDate(),
                        const SizedBox(
                          height: 2,
                        ),
                        const Text(
                          "Blog",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 40,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const CardPost(),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              "Popular",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ShowMorePostPage(
                                              arg: 1,
                                            )));
                              },
                              child: const Text(
                                "Show all",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.deepOrange),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const PopularPosts(),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
  }
}
