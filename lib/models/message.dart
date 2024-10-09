class Message {
  final String content;
  final int? senderId;
  final String? senderName;
  final DateTime? timestamp;

  Message({
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'] as String? ?? '',
      senderId: json['sender_id'] as int?,
      senderName: json['sender_name'] as String?,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
    );
  }
}
