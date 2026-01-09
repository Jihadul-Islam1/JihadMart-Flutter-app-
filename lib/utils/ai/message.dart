class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage._(this.text, this.isUser);

  factory ChatMessage.user(String text) => ChatMessage._(text, true);
  factory ChatMessage.ai(String text) => ChatMessage._(text, false);
}
