import 'package:blog_app/view/pages/comment_page.dart';
import 'package:blog_app/view/pages/detail_post_page.dart';
import 'package:blog_app/view/pages/post_form_page.dart';
import 'package:blog_app/view_model/comment_view_model.dart';
import 'package:blog_app/view_model/post_view_model.dart';
import 'package:flutter/material.dart';

import 'package:blog_app/model/models/post.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PopularPosts extends StatefulWidget {
  const PopularPosts({Key? key}) : super(key: key);

  @override
  State<PopularPosts> createState() => _PopularPostsState();
}

class _PopularPostsState extends State<PopularPosts> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PostViewModel>(
      builder: (context, value, child) => value.postsPopular.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.post_add_outlined, size: 200),
                  Text(
                    'No post yet',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                  Text(
                    'Be the first to post.',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  )
                ],
              ),
            )
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:
                  value.postsPopular.length > 3 ? 3 : value.postsPopular.length,
              itemBuilder: (BuildContext context, int index) {
                Post post = value.postsPopular[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                      onTap: () async {
                        await context
                            .read<CommentViewModel>()
                            .getComments(post.id ?? 0);
                        if (mounted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPostPage(
                                        post: post,
                                        index: index,
                                        isPopuler: true,
                                      )));
                        }
                      },
                      child: Stack(
                        children: [
                          Row(
                            children: <Widget>[
                              Hero(
                                tag: 'animasi2${post.id}',
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.elliptical(20, 20)),
                                    child: Image.network(
                                      post.image.toString(),
                                      fit: BoxFit.cover,
                                      height: 90,
                                      width: 90,
                                    ),
                                  ),
                                ),
                              ),
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
                          ),
                        ],
                      )),
                );
              }),
    );
  }
}
