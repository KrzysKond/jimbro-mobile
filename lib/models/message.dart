class Message {
  final String content;
  final int? sender;

  Message({
    required this.content,
    required this.sender,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['message'] as String? ?? '',
      sender: json['sender_id'] as int?,
     // timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
