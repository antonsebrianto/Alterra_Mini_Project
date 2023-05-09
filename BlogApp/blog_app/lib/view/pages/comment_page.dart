import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:blog_app/model/models/comment.dart';
import 'package:blog_app/view_model/comment_view_model.dart';
import 'package:blog_app/view_model/post_view_model.dart';

class CommentPage extends StatefulWidget {
  final int? postId;

  const CommentPage({
    Key? key,
    this.postId,
  }) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  int _editCommentId = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    context.read<CommentViewModel>().getComments(widget.postId ?? 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Comments'),
        ),
        body: Consumer<CommentViewModel>(
          builder: (context, value, child) => Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  child: value.listComments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.mode_comment_outlined, size: 200),
                              Text(
                                'No comments yet',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 16),
                              ),
                              Text(
                                'Be the first to comment.',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              )
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: value.listComments.length,
                          itemBuilder: (BuildContext context, int index) {
                            Comment comment = value.listComments[index];
                            return Container(
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white24,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius
                                                        .all(
                                                    Radius.elliptical(12, 12)),
                                                image: DecorationImage(
                                                    image: comment
                                                                .user!.image ==
                                                            null
                                                        ? const NetworkImage(
                                                            'https://upload.wikimedia.org/wikipedia/commons/3/34/PICA.jpg')
                                                        : NetworkImage(comment
                                                            .user!.image
                                                            .toString()),
                                                    fit: BoxFit.cover)),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            '${comment.user!.name}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      ),
                                      comment.user!.id ==
                                              context
                                                  .read<CommentViewModel>()
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
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Icon(
                                                  Icons.more_vert,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              onSelected: (value) {
                                                if (value == 'edit') {
                                                  setState(() {
                                                    _editCommentId =
                                                        comment.id ?? 0;
                                                  });
                                                  _commentController.text =
                                                      comment.comment ?? '';
                                                } else {
                                                  context
                                                      .read<CommentViewModel>()
                                                      .deleteComment(
                                                          widget.postId ?? 0,
                                                          comment.id ?? 0);
                                                }
                                              },
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text('${comment.comment}'),
                                ],
                              ),
                            );
                          },
                        ),
                  onRefresh: () {
                    return context
                        .read<CommentViewModel>()
                        .getComments(widget.postId ?? 0);
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.white24,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                            labelText: 'Comment',
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.white))),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (_commentController.text.isNotEmpty) {
                          if (_editCommentId > 0) {
                            context.read<CommentViewModel>().editComment(
                                widget.postId ?? 0,
                                _editCommentId,
                                _commentController.text);
                            _commentController.text = '';
                          } else {
                            await context
                                .read<CommentViewModel>()
                                .createComment(widget.postId ?? 0,
                                    _commentController.text);
                            _commentController.text = '';

                            if (mounted) {
                              context
                                  .read<PostViewModel>()
                                  .retrievePostsPopular();
                            }
                          }
                        }
                      },
                      icon: const Icon(Icons.send),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
