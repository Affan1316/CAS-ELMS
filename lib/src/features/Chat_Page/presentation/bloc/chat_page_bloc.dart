import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import 'messages.dart';

part 'chat_page_event.dart';
part 'chat_page_state.dart';

Future<String> systemInstruction() async {
  return await rootBundle.loadString(
    'assets/markDown/cas_ai_system_instruction.md',
  );
}

class ChatPageBloc extends Bloc<ChatPageEvent, ChatPageState> {
  GenerativeModel? _model;
  ChatSession? _chat;

  void _loadModel() async {
    bool hasInternet = await checkInternetConnection();
    if (hasInternet) {
      try {
        final systemInstructionText = await systemInstruction();
        _model = FirebaseAI.googleAI().generativeModel(
          model: 'gemini-2.0-flash',
          systemInstruction: Content.system(systemInstructionText),
        );
        _chat = _model!.startChat();
      } catch (e) {
        _model = null;
        _chat = null;
      }
    } else {
      _model = null;
      _chat = null;
    }
  }

  ChatPageBloc() : super(ChatPageInitialState()) {
    _loadModel();
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatPageState> emit,
  ) async {
    bool hasInternet = await checkInternetConnection();
    if (_model == null || _chat == null) {
      _loadModel();
    }

    // Create the user's message
    final userMessage = Message(
      text: event.text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Create a temporary "typing" message
    final typingMessage = Message(
      text: '',
      isUser: false,
      isTyping: true, // This flag will trigger your typing UI
      timestamp: DateTime.now(),
    );

    // Add both messages and emit the loading state
    final loadingMessages = [...state.messages, userMessage, typingMessage];
    emit(ChatLoadingState(messages: loadingMessages));

    try {
      final response = hasInternet
          ? await _chat?.sendMessage(Content.text(event.text))
          : null;
      String? responseText;

      if (response == null) {
        responseText =
            '❌ Network Error: Please check your internet connection.';
      } else {
        responseText = response.text;
      }

      // Create the final AI message
      final aiMessage = Message(
        text: responseText!,
        isUser: false,
        timestamp: DateTime.now(),
      );

      // Create the final list by removing the typing indicator and adding the real message
      final finalMessages = List<Message>.from(loadingMessages)
        ..remove(typingMessage) // Removes the typing message
        ..add(aiMessage); // Adds the actual AI response

      emit(ChatSuccessState(messages: finalMessages));
    } catch (e) {
      // Determine the error message text
      final String errorText;
      if (e is SocketException) {
        errorText = '❌ Network Error: Please check your internet connection.';
      } else {
        errorText = '⚠️ Unexpected error. Please try again.';
      }

      // Create a final error message to display in the chat
      final errorMessage = Message(
        text: errorText,
        isUser: false,
        timestamp: DateTime.now(),
      );

      // Also replace the typing indicator with the error message
      final finalMessages = List<Message>.from(loadingMessages)
        ..remove(typingMessage) // Removes the typing message
        ..add(errorMessage); // Adds the error message

      emit(ChatFailureState(messages: finalMessages, error: e.toString()));
    }
  }
}

Future<bool> checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

// Future<void> sendIfConnected(Function action) async {
//   final hasInternet = await checkInternetConnection();
//   if (hasInternet) {
//     action();
//   } else {
//     print("No internet.");
//   }
// }
