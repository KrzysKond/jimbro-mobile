
class Comment{
  final String text;
  final String authorName;
  final DateTime? createdAt;

  Comment({
    required this.text,
    required this.authorName,
    required this.createdAt});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      text: json['text'],
      authorName: json['author'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,    );
  }
}