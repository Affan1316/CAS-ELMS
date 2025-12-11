import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../presentation/bloc/messages.dart';

class DeepSeekService {
  // ⚠️ Replace with your actual DeepSeek API Key
  final String _apiKey = "sk-44d13df5b178479aa65dafed9258ff9e"; 
  final String _baseUrl = 'https://api.deepseek.com/chat/completions';

  Future<String?> sendMessage({
    required List<Message> history, // We pass your existing message list here
    String? systemInstruction,
  }) async {
    try {
      // 1. Convert your 'Message' model list to DeepSeek's JSON format
      List<Map<String, String>> apiMessages = [];

      // A. Add System Instruction (if exists)
      if (systemInstruction != null) {
        apiMessages.add({
          "role": "system",
          "content": systemInstruction,
        });
      }

      // B. Add Chat History
      // We filter out 'isTyping' messages or empty errors if necessary
      for (var msg in history) {
        // Skip messages that are just loading indicators
        if (msg.isTyping == true) continue; 

        apiMessages.add({
          "role": msg.isUser ? "user" : "assistant",
          "content": msg.text,
        });
      }

      // 2. Make the HTTP Request
      log("apiMessages : $apiMessages  && APi Key : $_apiKey");
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "deepseek-chat",
          "messages": apiMessages,
          "temperature": 1.3, // Recommended for DeepSeek-V3
          "stream": false,
        }),
      );

      // 3. Handle Response
      if (response.statusCode == 200) {
        // Decode specifically as UTF-8 to handle emojis/special chars correctly
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      } else {
        print("DeepSeek API Error: ${response.statusCode} - ${response.body}");
        throw Exception('Failed to fetch response: ${response.statusCode}');
      }
    } catch (e) {
      print("DeepSeek Service Exception: $e");
      rethrow;
    }
  }
}