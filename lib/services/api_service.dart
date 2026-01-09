import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Using a free AI API - no key required for basic usage
  // You can also use: https://api.openai.com or other providers

  Future<String> getCompletion(String prompt) async {
    try {
      // Using a free chat completion API
      final response = await http.post(
        Uri.parse('https://api.cohere.ai/v1/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer trial', // Cohere has a free trial
        },
        body: jsonEncode({'message': prompt, 'model': 'command'}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['text'] ?? 'No response received';
      }
    } catch (e) {
      // Fallback to simple response
    }

    // Simple offline fallback responses for e-commerce app
    return _getOfflineResponse(prompt);
  }

  String _getOfflineResponse(String prompt) {
    final lowerPrompt = prompt.toLowerCase();

    if (lowerPrompt.contains('hello') ||
        lowerPrompt.contains('hi') ||
        lowerPrompt.contains('হ্যালো')) {
      return "Hello! 👋 Welcome to our e-commerce app. How can I help you today?\n\nI can assist you with:\n• Product recommendations\n• Order tracking\n• Payment methods\n• Shipping information";
    }

    if (lowerPrompt.contains('order') || lowerPrompt.contains('অর্ডার')) {
      return "📦 For order related queries:\n\n• To track your order, go to Menu → My Orders\n• Orders are usually delivered within 3-5 business days\n• You'll receive SMS updates for your order status";
    }

    if (lowerPrompt.contains('payment') ||
        lowerPrompt.contains('pay') ||
        lowerPrompt.contains('পেমেন্ট')) {
      return "💳 We accept multiple payment methods:\n\n• Bkash\n• Nagad\n• Rocket\n• Credit/Debit Cards\n• Cash on Delivery\n\nAll transactions are secure and encrypted!";
    }

    if (lowerPrompt.contains('shipping') ||
        lowerPrompt.contains('delivery') ||
        lowerPrompt.contains('ডেলিভারি')) {
      return "🚚 Shipping Information:\n\n• We deliver all over Bangladesh\n• Dhaka: 1-2 days\n• Outside Dhaka: 3-5 days\n• Shipping charge: ৳60-120 based on location";
    }

    if (lowerPrompt.contains('return') ||
        lowerPrompt.contains('refund') ||
        lowerPrompt.contains('রিটার্ন')) {
      return "🔄 Return Policy:\n\n• 7-day easy return policy\n• Product must be unused with tags\n• Refund processed within 5-7 days\n• Contact support for return requests";
    }

    if (lowerPrompt.contains('discount') ||
        lowerPrompt.contains('offer') ||
        lowerPrompt.contains('ছাড়')) {
      return "🎉 Current Offers:\n\n• New users get 10% off on first order\n• Free delivery on orders above ৳1000\n• Check the home page for flash sales!\n• Use code WELCOME10 for discount";
    }

    if (lowerPrompt.contains('product') || lowerPrompt.contains('প্রোডাক্ট')) {
      return "🛍️ Product Help:\n\n• Browse categories from the home page\n• Use search to find specific products\n• Add to wishlist by tapping the heart icon\n• Check product details for size guides";
    }

    if (lowerPrompt.contains('thank') || lowerPrompt.contains('ধন্যবাদ')) {
      return "You're welcome! 😊 Happy shopping! If you need any more help, feel free to ask.";
    }

    return "I'm your shopping assistant! 🛒\n\nI can help you with:\n• Order tracking\n• Payment methods\n• Shipping & delivery\n• Returns & refunds\n• Product recommendations\n• Current offers\n\nJust ask me anything!";
  }
}

// Riverpod provider for ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});
