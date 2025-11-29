import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// CHANGE 1: Remove Firebase import, use this instead
import 'package:google_generative_ai/google_generative_ai.dart';

import 'messages.dart';

part 'chat_page_event.dart';
part 'chat_page_state.dart';

class ChatPageBloc extends Bloc<ChatPageEvent, ChatPageState> {
  GenerativeModel? _model;
  ChatSession? _chat;

  // Ideally, use flutter_dotenv to load this securely
  final String _apiKey = 'AIzaSyABlF_PCONYAwqfaTCGKDdU-L2edwodFjY';

  ChatPageBloc() : super(ChatPageInitialState()) {
    on<InitializeChatEvent>(_onInitializeChat);
    on<SendMessageEvent>(_onSendMessage);

    add(InitializeChatEvent());
  }

  Future<void> _onInitializeChat(
    InitializeChatEvent event,
    Emitter<ChatPageState> emit,
  ) async {
    _model = null;
    _chat = null;

    if (!await _checkInternetConnection()) {
      return;
    }

    try {
      final systemInstructionText = await rootBundle.loadString(
        'assets/markDown/cas_ai_system_instruction.md',
      );

      // CHANGE 2: Direct GenerativeModel initialization
      // Note: Use 'gemini-1.5-flash', there is no 2.5 yet.
      _model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: _apiKey,
        systemInstruction: Content.system(systemInstructionText),
      );

      _chat = _model!.startChat();
    } catch (e) {
      debugPrint('Failed to initialize Generative Model: $e');
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatPageState> emit,
  ) async {
    // ... (Your existing UI update logic remains exactly the same) ...

    final userMessage = Message(
      text: event.text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    final typingMessage = Message(
      text: '',
      isUser: false,
      isTyping: true,
      timestamp: DateTime.now(),
    );

    final loadingMessages = [...state.messages, userMessage, typingMessage];
    emit(ChatLoadingState(messages: loadingMessages));

    // ... (Your internet check logic) ...

    try {
      // CHANGE 3: Content.text() is the same, but the object structure
      // is slightly cleaner in this package.
      final response = await _chat!.sendMessage(Content.text(event.text));
      final responseText = response.text ?? 'An unexpected error occurred.';

      final aiMessage = Message(
        text: responseText,
        isUser: false,
        timestamp: DateTime.now(),
      );

      final finalMessages =
          List<Message>.from(loadingMessages)
            ..remove(typingMessage)
            ..add(aiMessage);

      emit(ChatSuccessState(messages: finalMessages));
    } catch (e) {
      // ... (Your error handling logic) ...
      log("error at response ${e.toString()}");
      _handleError(
        emit,
        loadingMessages,
        typingMessage,
        '⚠️ Unexpected error.',
        error: e.toString(),
      );
    }
  }

  // ... (Keep your _checkInternetConnection and _handleError helpers) ...
  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  void _handleError(
    Emitter<ChatPageState> emit,
    List<Message> currentMessages,
    Message typingMessage,
    String errorText, {
    String? error,
  }) {
    final errorMessage = Message(
      text: errorText,
      isUser: false,
      timestamp: DateTime.now(),
    );

    final finalMessages =
        List<Message>.from(currentMessages)
          ..remove(typingMessage)
          ..add(errorMessage);

    emit(ChatFailureState(messages: finalMessages, error: error ?? errorText));
  }
}
