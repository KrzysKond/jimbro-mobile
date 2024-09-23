class Workout {
  final int id;
  final String title;
  final String? photoUrl;
  final DateTime date;
  final String username;

  Workout({
    required this.id,
    required this.title,
    required this.photoUrl,
    required this.date,
    required this.username
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as int,
      title: json['title'],
      photoUrl: json['image'],
      date: DateTime.parse(json['date']),
      username: json['username']
    );
  }
}
