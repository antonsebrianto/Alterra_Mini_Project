import 'package:blog_app/view/widgets/show_more_post.dart';
import 'package:blog_app/view_model/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowMorePostPage extends StatefulWidget {
  final int arg;
  const ShowMorePostPage({Key? key, required this.arg}) : super(key: key);

  @override
  State<ShowMorePostPage> createState() => _ShowMorePostPageState();
}

class _ShowMorePostPageState extends State<ShowMorePostPage> {
  int _arg = 0;
  bool selfLiked = true;

  @override
  void initState() {
    _arg = widget.arg;
    context.read<PostViewModel>().retrievePosts();
    context.read<PostViewModel>().retrievePostsPopular();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: context.read<PostViewModel>().loading
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
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            const SizedBox(
                              height: 50,
                            ),
                            ShowMorePost(arg: _arg),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ));
  }
}
