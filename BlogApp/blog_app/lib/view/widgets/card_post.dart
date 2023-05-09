import 'package:blog_app/view/pages/detail_post_page.dart';
import 'package:blog_app/view/pages/post_form_page.dart';
import 'package:blog_app/view/pages/show_more_post_page.dart';
import 'package:blog_app/view_model/comment_view_model.dart';
import 'package:blog_app/view_model/post_view_model.dart';
import 'package:flutter/material.dart';

import 'package:blog_app/model/models/post.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CardPost extends StatefulWidget {
  const CardPost({
    Key? key,
  }) : super(key: key);

  @override
  State<CardPost> createState() => _CardPostState();
}

class _CardPostState extends State<CardPost> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PostViewModel>(
      builder: (context, value, child) => SizedBox(
        width: 350,
        height: 350,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: value.posts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.post_add_outlined, size: 200),
                      Text(
                        'No post yet',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                      Text(
                        'Be the first to post.',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: value.posts.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    Post post = value.posts[index];

                    if (index == 3) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ShowMorePostPage(
                                        arg: 0,
                                      )));
                        },
                        child: const SizedBox(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: Text(
                              'Show More',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return InkWell(
                          hoverColor: Colors.white70,
                          enableFeedback: true,
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
                                          )));
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 30),
                            height: 350,
                            width: 350,
                            child: Stack(
                              children: [
                                Hero(
                                  tag: 'animasi1${post.id}',
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.elliptical(20, 20)),
                                    child: Image.network(
                                      post.image.toString(),
                                      fit: BoxFit.cover,
                                      height: 350,
                                      width: 350,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Stack(
                                            alignment: Alignment.topLeft,
                                            children: <Widget>[
                                              post.user?.id ==
                                                      context
                                                          .read<PostViewModel>()
                                                          .userId
                                                  ? PopupMenuButton(
                                                      itemBuilder: (context) =>
                                                          [
                                                        const PopupMenuItem(
                                                          value: 'edit',
                                                          child: Text('Edit'),
                                                        ),
                                                        const PopupMenuItem(
                                                          value: 'delete',
                                                          child: Text('Delete'),
                                                        ),
                                                      ],
                                                      child: const Icon(
                                                        Icons.more_vert,
                                                        color: Colors.white,
                                                        size: 28,
                                                      ),
                                                      onSelected: (value) {
                                                        if (value == 'edit') {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    PostForm(
                                                              title:
                                                                  'Edit Post',
                                                              post: post,
                                                            ),
                                                          ));
                                                        } else {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Delete'),
                                                                  content: Text(
                                                                      'Are you sure want to delete this ${post.subtitle} post?'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: const Text(
                                                                          'Cancel'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        context
                                                                            .read<
                                                                                PostViewModel>()
                                                                            .handleDeletePost(post.id ??
                                                                                0);
                                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 100,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20,
                                          top: 20,
                                          bottom: 10),
                                      child: Stack(
                                        alignment: Alignment.bottomLeft,
                                        children: <Widget>[
                                          Text(
                                            post.subtitle.toString(),
                                            style: const TextStyle(
                                                fontSize: 24,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0,
                                              right: 20,
                                              top: 20,
                                              bottom: 10),
                                          child: Stack(
                                            alignment: Alignment.bottomLeft,
                                            children: <Widget>[
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.elliptical(
                                                                12, 12)),
                                                    image: DecorationImage(
                                                        image: post.user!
                                                                    .image ==
                                                                null
                                                            ? const NetworkImage(
                                                                'https://upload.wikimedia.org/wikipedia/commons/3/34/PICA.jpg')
                                                            : NetworkImage(post
                                                                .user!.image
                                                                .toString()),
                                                        fit: BoxFit.cover)),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              post.user!.name.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                const Icon(
                                                  Icons.access_time,
                                                  size: 16,
                                                  color: Colors.white70,
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(DateTime.parse(
                                                          "${post.createdAt}")),
                                                  style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 14),
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ));
                    }
                  },
                ),
        ),
      ),
    );
  }
}
