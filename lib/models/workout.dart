import 'dart:ffi';

import 'package:jimbro_mobile/models/comment.dart';

class Workout {
  final int id;
  final String title;
  final String? photoUrl;
  final DateTime date;
  final String username;
 // List<Comment> comments;
  int fires;
  int commentsCount;
  bool isLiked;

  Workout({
    required this.id,
    required this.title,
    required this.photoUrl,
    required this.date,
    required this.username,
    required this.isLiked,
    this.fires = 0,
    this.commentsCount = 0,
   // required this.comments,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    /*var commentList = json['comments'] as List<dynamic>?;
    List<Comment> comments = commentList != null
        ? commentList.map((commentJson) => Comment.fromJson(commentJson)).toList()
        : [];*/
    return Workout(
      id: json['id'] as int,
      title: json['title'],
      photoUrl: json['image'],
      date: DateTime.parse(json['date']),
      username: json['username'],
      fires: json['fires'],
      isLiked: json['isLiked'],
      commentsCount: json['comments_count'] as int,
    //  comments: comments
    );
  }
}
