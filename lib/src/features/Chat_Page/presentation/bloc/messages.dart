import 'dart:convert';

import 'package:flutter/widgets.dart';

class Message {
  final String text;

  final DateTime? timestamp;
  final bool isUser;
  final bool isTyping;

  Message({
    required this.text,
    this.timestamp,
    required this.isUser,
    this.isTyping = false,
  });

  Message copyWith({
    String? text,
    ValueGetter<DateTime?>? timestamp,
    bool? isUser,
    bool? isTyping,
  }) {
    return Message(
      text: text ?? this.text,
      timestamp: timestamp != null ? timestamp() : this.timestamp,
      isUser: isUser ?? this.isUser,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'isUser': isUser,
      'isTyping': isTyping,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['text'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'])
          : null,
      isUser: map['isUser'] ?? false,
      isTyping: map['isTyping'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(text: $text, timestamp: $timestamp, isUser: $isUser, isTyping: $isTyping)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.text == text &&
        other.timestamp == timestamp &&
        other.isUser == isUser &&
        other.isTyping == isTyping;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        timestamp.hashCode ^
        isUser.hashCode ^
        isTyping.hashCode;
  }
}
