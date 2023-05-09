import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:blog_app/model/models/post.dart';
import 'package:blog_app/view/pages/comment_page.dart';
import 'package:blog_app/view_model/comment_view_model.dart';
import 'package:blog_app/view_model/post_view_model.dart';

class BottomSheetContent extends StatelessWidget {
  final double height;
  final double width;
  final Post post;
  const BottomSheetContent({
    Key? key,
    required this.height,
    required this.width,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: height / 20),
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              post.title ?? '',
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              post.subtitle ?? '',
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: <Widget>[
                const Icon(
                  Icons.access_time,
                  color: Colors.grey,
                  size: 16,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  DateFormat('dd-MM-yyyy')
                      .format(DateTime.parse(post.createdAt.toString())),
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(
                  width: 20,
                ),
                Consumer<PostViewModel>(
                  builder: (context, value, child) => Row(
                    children: [
                      IconButton(
                        icon: post.selfLiked == true
                            ? Icon(
                                Icons.thumb_up,
                                size: 16,
                                color: Colors.red[400],
                              )
                            : Icon(
                                Icons.thumb_up,
                                size: 16,
                                color: Colors.grey[400],
                              ),
                        onPressed: () {
                          context
                              .read<PostViewModel>()
                              .handlePostLikeOrUnlike(post.id ?? 0);
                          context
                              .read<PostViewModel>()
                              .retrieveSinglePost(post.id ?? 0);
                        },
                      ),
                      Text(
                        post.likesCount.toString(),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 12)),
                IconButton(
                  icon: Icon(
                    Icons.comment,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentPage(
                          postId: post.id,
                        ),
                      ),
                    );
                  },
                ),
                Consumer<CommentViewModel>(
                  builder: (context, value, child) => Text(
                    value.listComments.length.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: post.user!.image == null
                              ? const NetworkImage(
                                  'https://upload.wikimedia.org/wikipedia/commons/3/34/PICA.jpg')
                              : NetworkImage(post.user?.image ?? ''))),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  post.user!.name ?? '',
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              post.body ?? '',
              style: const TextStyle(
                  color: Colors.black54, fontSize: 16.5, height: 1.4),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
