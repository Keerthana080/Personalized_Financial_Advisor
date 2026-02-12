// services/ai_chat_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class AiChatService {
  static const String _baseUrl = "http://192.168.246.90:8000";
  // Use http://127.0.0.1:8000 for web

  static Future<String> ask({
    required String userId,
    required String question,
    required Map<String, dynamic> financialContext,
  }) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/chat"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "question": question,
        "context": financialContext,

        // 👇 THIS IS THE KEY CHANGE
        "instructions":
            "Answer briefly in 3-5 sentences. "
            "Be practical, clear, and conversational. "
            "Avoid long explanations. "
            "If helpful, use short bullet points.",
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["response"];
    } else {
      throw Exception("AI request failed");
    }
  }
}
