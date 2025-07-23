part of 'chat_page_bloc.dart';

@immutable
abstract class ChatPageState {
  final List<Message> messages;
  const ChatPageState({required this.messages});
}

@immutable
class ChatPageInitialState extends ChatPageState {
  ChatPageInitialState()
    : super(
        messages: [
          Message(
            text: 'Hi! I\'m here to assist you for any queries related to CAS',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        ],
      );
}

// State when waiting for a response from the AI
class ChatLoadingState extends ChatPageState {
  const ChatLoadingState({required super.messages});
}

// State after successfully receiving a response
class ChatSuccessState extends ChatPageState {
  const ChatSuccessState({required super.messages});
}

// State when an error occurs (e.g., no internet)
class ChatFailureState extends ChatPageState {
  final String error;
  const ChatFailureState({required super.messages, required this.error});
}
