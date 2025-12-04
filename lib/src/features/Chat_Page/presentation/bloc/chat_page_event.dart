part of 'chat_page_bloc.dart';

@immutable
abstract class ChatPageEvent {
  const ChatPageEvent();
}

class SendMessageEvent extends ChatPageEvent {
  final String text;

  const SendMessageEvent({required this.text});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SendMessageEvent &&
          runtimeType == other.runtimeType &&
          text == other.text;

  @override
  int get hashCode => text.hashCode;
}

class InitializeChatEvent extends ChatPageEvent {}
