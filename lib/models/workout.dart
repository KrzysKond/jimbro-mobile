import 'dart:ffi';

class Workout {
  final int id;
  final String title;
  final String? photoUrl;
  final DateTime date;
  final String username;
  int fires;
  bool isLiked;

  Workout({
    required this.id,
    required this.title,
    required this.photoUrl,
    required this.date,
    required this.username,
    this.fires = 0,
    required this.isLiked,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as int,
      title: json['title'],
      photoUrl: json['image'],
      date: DateTime.parse(json['date']),
      username: json['username'],
      fires: json['fires'],
      isLiked: json['isLiked']
    );
  }
}
