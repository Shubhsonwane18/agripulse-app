class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? audioUrl;
  final String? detectedLanguage;
  final List<String>? quickReplies;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.audioUrl,
    this.detectedLanguage,
    this.quickReplies,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    var rawReplies = (json['quick_replies'] ?? json['quickReplies'] ?? []) as List;
    return ChatMessage(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      text: json['text']?.toString() ?? '',
      isUser: json['is_user'] == true || json['isUser'] == true,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      audioUrl: json['audio_url']?.toString() ?? json['audioUrl']?.toString(),
      detectedLanguage: json['detected_language']?.toString(),
      quickReplies: rawReplies.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'is_user': isUser,
      'timestamp': timestamp.toIso8601String(),
      'audio_url': audioUrl,
      'detected_language': detectedLanguage,
      'quick_replies': quickReplies,
    };
  }
}
