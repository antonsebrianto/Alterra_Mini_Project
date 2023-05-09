import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:blog_app/model/models/api_response.dart';
import 'package:blog_app/model/models/post.dart';
import 'package:blog_app/view_model/post_view_model.dart';

class PostForm extends StatefulWidget {
  final Post? post;
  final String? title;

  const PostForm({
    Key? key,
    this.post,
    this.title,
  }) : super(key: key);

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  ApiResponse? apiResponse;

  void createPost() async {
    if (await context.read<PostViewModel>().createPost(_titleController.text,
        _subtitleController.text, _bodyController.text)) {
      context.read<PostViewModel>().loading !=
          context.read<PostViewModel>().loading;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Post created')));
      Navigator.pop(context);
      context.read<PostViewModel>().retrievePosts();
      context.read<PostViewModel>().retrievePostsPopular();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${apiResponse?.error}')));
    }
  }

  void editPost() async {
    if (await context.read<PostViewModel>().editPost(
        widget.post!.id ?? 0,
        _titleController.text,
        _subtitleController.text,
        _bodyController.text)) {
      context.read<PostViewModel>().loading !=
          context.read<PostViewModel>().loading;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Post edited')));
      Navigator.pop(context);
      context.read<PostViewModel>().retrievePosts();
      context.read<PostViewModel>().retrievePostsPopular();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${apiResponse?.error}')));
    }
  }

  @override
  void initState() {
    if (widget.post != null) {
      _titleController.text = widget.post!.title ?? '';
      _subtitleController.text = widget.post!.subtitle ?? '';
      _bodyController.text = widget.post!.body ?? '';
    }
    context.read<PostViewModel>().fileImage = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.title}')),
      body: context.read<PostViewModel>().loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                widget.post != null
                    ? const SizedBox()
                    : Consumer<PostViewModel>(
                        builder: (context, value, child) => Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: BoxDecoration(
                            image: value.fileImage == null
                                ? null
                                : DecorationImage(
                                    image: FileImage(
                                      value.fileImage ?? File(''),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          child: Center(
                            child: IconButton(
                              icon: const Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.black38,
                              ),
                              onPressed: () {
                                context.read<PostViewModel>().getImage();
                              },
                            ),
                          ),
                        ),
                      ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          maxLines: 1,
                          validator: (value) =>
                              value!.isEmpty ? 'Post title is required' : null,
                          decoration: const InputDecoration(
                              hintText: "Post title",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.black38))),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: _subtitleController,
                          maxLines: 2,
                          validator: (value) => value!.isEmpty
                              ? 'Post subtitle is required'
                              : null,
                          decoration: const InputDecoration(
                              hintText: "Post subtitle",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.black38))),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: _bodyController,
                          maxLines: 9,
                          validator: (value) =>
                              value!.isEmpty ? 'Post body is required' : null,
                          decoration: const InputDecoration(
                              hintText: "Post body ...",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.black38))),
                        ),
                      ],
                    ),
                  ),
                ),
                Consumer<PostViewModel>(
                  builder: (context, value, child) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.post == null) {
                            if (value.fileImage != File('') ||
                                value.fileImage != null) {
                              createPost();
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Update'),
                                    content: Text(
                                        'Are you sure want to update this ${widget.post!.subtitle} post?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          editPost();
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Confirm'),
                                      ),
                                    ],
                                  );
                                });
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
