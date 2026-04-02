class ChatMessage {
  final String role; // 'user' or 'ai'
  final String content;
  final int timestamp;
  final String? imagePath; // Local file path for image messages

  ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
    this.imagePath,
  });

  bool get isUser => role == 'user';
  bool get hasImage => imagePath != null && imagePath!.isNotEmpty;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'] ?? 'user',
      content: json['content'] ?? '',
      timestamp: json['timestamp'] ?? 0,
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
      'timestamp': timestamp,
      if (imagePath != null) 'imagePath': imagePath,
    };
  }

  factory ChatMessage.user(String content, {String? imagePath}) {
    return ChatMessage(
      role: 'user',
      content: content,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      imagePath: imagePath,
    );
  }

  factory ChatMessage.ai(String content) {
    return ChatMessage(
      role: 'ai',
      content: content,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
