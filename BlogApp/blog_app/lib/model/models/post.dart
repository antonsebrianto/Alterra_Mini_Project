import 'package:blog_app/model/models/user.dart';

class Post {
  int? id;
  String? title;
  String? subtitle;
  String? body;
  String? image;
  String? createdAt;
  int? likesCount;
  int? commentsCount;
  User? user;
  bool? selfLiked;

  Post({
    this.id,
    this.title,
    this.subtitle,
    this.body,
    this.image,
    this.createdAt,
    this.likesCount,
    this.commentsCount,
    this.user,
    this.selfLiked,
  });

  // MAP JSON TO POST MODEL
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        title: json['title'],
        subtitle: json['subtitle'],
        body: json['body'],
        image: json['image'],
        createdAt: json['created_at'],
        likesCount: json['likes_count'],
        commentsCount: json['comments_count'],
        selfLiked: json['likes'].length > 0,
        user: User(
            id: json['user']['id'],
            name: json['user']['name'],
            image: json['user']['image']));
  }
}
