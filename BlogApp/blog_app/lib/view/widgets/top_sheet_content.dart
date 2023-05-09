import 'package:flutter/material.dart';

import 'package:blog_app/model/models/post.dart';

class TopSheetContent extends StatelessWidget {
  final double height;
  final Post post;
  final bool isPressed;
  final bool isPopuler;
  const TopSheetContent({
    Key? key,
    required this.height,
    required this.post,
    required this.isPressed,
    this.isPopuler = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isPopuler == false
            ? Hero(
                tag: 'animasi1${post.id}',
                child: Image.network(
                  post.image ?? '',
                  fit: BoxFit.cover,
                  height: height / 2,
                ))
            : Hero(
                tag: 'animasi2${post.id}',
                child: Image.network(
                  post.image ?? '',
                  fit: BoxFit.cover,
                  height: height / 2,
                )),
        Padding(
          padding: const EdgeInsets.only(top: 48, left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
