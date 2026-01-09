import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Simple singleton service that wraps Google Gemini text chat.
///
/// How to use:
/// - Put your API key in [GeminiService.apiKey]. Prefer reading from an env/secret.
/// - Call `GeminiService.instance.sendMessage("Hello")` to get a reply string.
class GeminiService {
  GeminiService._internal();
  static final GeminiService instance = GeminiService._internal();

  // TODO: Replace this with your Gemini API key. For safety, don't commit real keys.
  // Consider loading from runtime configuration or platform environment.
  static const String apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'AIzaSyB_nE94fkGuqjQXx38L6YieTXCsqcjS2D0',
  );

  // Default text model. You can change to other available models.
  static const String modelName = 'gemini-1.5-flash';

  GenerativeModel? _model;
  ChatSession? _chat;

  GenerativeModel _getModel() {
    final key = apiKey.trim();
    if (key.isEmpty || key == 'AIzaSyB_nE94fkGuqjQXx38L6YieTXCsqcjS2D0') {
      throw StateError(
        'Gemini API key is missing. Set GeminiService.apiKey or pass --dart-define=GEMINI_API_KEY=...',
      );
    }
    _model ??= GenerativeModel(model: modelName, apiKey: key);
    return _model!;
  }

  ChatSession _getChat() {
    _chat ??= _getModel().startChat();
    return _chat!;
  }

  /// Sends a user message and returns the AI text reply.
  Future<String> sendMessage(String message) async {
    final chat = _getChat();
    final content = Content.text(message);
    final response = await chat.sendMessage(content);
    final text = response.text?.trim();
    if (text == null || text.isEmpty) return "(No response)";
    return text;
  }

  /// Clears the chat session history.
  void reset() {
    _chat = null;
  }
}
