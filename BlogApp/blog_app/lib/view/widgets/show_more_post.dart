import 'package:blog_app/model/models/post.dart';
import 'package:blog_app/view/pages/comment_page.dart';
import 'package:blog_app/view/pages/detail_post_page.dart';
import 'package:blog_app/view/pages/post_form_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:blog_app/view_model/post_view_model.dart';

class ShowMorePost extends StatelessWidget {
  final int arg;
  const ShowMorePost({
    Key? key,
    required this.arg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PostViewModel>(
        builder: (context, value, child) => Column(
              children: [
                Text(
                  arg == 0 ? "All Posts" : "Popular Posts",
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: arg == 0
                        ? value.posts.length
                        : value.postsPopular.length,
                    itemBuilder: (BuildContext context, int index) {
                      Post post = arg == 0
                          ? value.posts[index]
                          : value.postsPopular[index];
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPostPage(
                                          post: post,
                                          index: index,
                                        )));
                          },
                          child: Row(
                            children: <Widget>[
                              Container(
                                  margin:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.elliptical(12, 12)),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              post.image.toString())))),
                              Padding(
                                padding: const EdgeInsets.only(left: 32.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      post.title ?? '',
                                      style: const TextStyle(
                                          color: Colors.deepOrange,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      post.subtitle ?? '',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 17),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        const IconButton(
                                            icon: Icon(
                                              Icons.access_time,
                                              size: 18,
                                            ),
                                            onPressed: null),
                                        Text(
                                          DateFormat('dd-MM-yyyy').format(
                                              DateTime.parse(
                                                  "${post.createdAt}")),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(left: 12)),
                                        IconButton(
                                          icon: post.selfLiked == true
                                              ? Icon(
                                                  Icons.thumb_up,
                                                  size: 18,
                                                  color: Colors.red[400],
                                                )
                                              : Icon(
                                                  Icons.thumb_up,
                                                  size: 18,
                                                  color: Colors.grey[400],
                                                ),
                                          onPressed: () {
                                            context
                                                .read<PostViewModel>()
                                                .handlePostLikeOrUnlike(
                                                    post.id ?? 0);
                                          },
                                        ),
                                        Text(
                                          post.likesCount.toString(),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.comment,
                                              size: 18,
                                              color: Colors.grey[400],
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CommentPage(
                                                              postId:
                                                                  post.id)));
                                            }),
                                        Text(
                                          post.commentsCount.toString(),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(
                                          width: 50,
                                        ),
                                        post.user?.id ==
                                                context
                                                    .read<PostViewModel>()
                                                    .userId
                                            ? PopupMenuButton(
                                                itemBuilder: (context) => [
                                                  const PopupMenuItem(
                                                    value: 'edit',
                                                    child: Text('Edit'),
                                                  ),
                                                  const PopupMenuItem(
                                                    value: 'delete',
                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                                child: const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: Icon(
                                                    Icons.more_vert,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                onSelected: (value) {
                                                  if (value == 'edit') {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          PostForm(
                                                        title: 'Edit Post',
                                                        post: post,
                                                      ),
                                                    ));
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Delete'),
                                                            content: Text(
                                                                'Are you sure want to delete this ${post.subtitle} post?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    'Cancel'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  context
                                                                      .read<
                                                                          PostViewModel>()
                                                                      .handleDeletePost(
                                                                          post.id ??
                                                                              0);
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(const SnackBar(
                                                                          content:
                                                                              Text('Delete successfull')));
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    'Confirm'),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  }
                                                },
                                              )
                                            : const SizedBox(),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ));
                    }),
              ],
            ));
  }
}
