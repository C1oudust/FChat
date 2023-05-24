class Message {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;

  Message({required this.id, required this.content, required this.isUser, required this.timestamp});

  Map<String, dynamic> toJson() => {
        'content': content,
        'isUser': isUser,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        content: json['content'],
        isUser: json['isUser'],
        timestamp: DateTime.parse(json['timestamp']),
      );

  Message copyWith({String? content, bool? isUser, DateTime? timestamp}) =>
      Message(id: id, content: content ?? this.content, isUser: isUser ?? this.isUser, timestamp: timestamp ?? this.timestamp);
}
