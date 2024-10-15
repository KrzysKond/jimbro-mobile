import 'dart:ffi';

import 'package:jimbro_mobile/models/comment.dart';

class Workout {
  final int id;
  final String title;
  final String? photoUrl;
  final DateTime date;
  final String username;
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
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as int,
      title: json['title'],
      photoUrl: json['image'],
      date: DateTime.parse(json['date']),
      username: json['username'],
      fires: json['fires'],
      isLiked: json['isLiked'],
      commentsCount: json['comments_count'] as int,
    );
  }
}
