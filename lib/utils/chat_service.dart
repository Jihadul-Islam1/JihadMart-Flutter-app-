// Chat Support / Customer Service
class ChatSupportService {
  static final List<Map<String, dynamic>> _conversations = [
    {
      'id': 'conv1',
      'subject': 'Order Delivery Issue',
      'status': 'resolved',
      'createdAt': DateTime.now().subtract(Duration(days: 5)),
      'lastMessage': 'Your order has been delivered. Thank you!',
      'unread': 0,
    },
    {
      'id': 'conv2',
      'subject': 'Return Request',
      'status': 'open',
      'createdAt': DateTime.now().subtract(Duration(hours: 2)),
      'lastMessage': 'Please share the product images.',
      'unread': 1,
    },
  ];

  static final List<Map<String, dynamic>> _messages = [
    {
      'id': 'msg1',
      'conversationId': 'conv2',
      'sender': 'user',
      'message': 'I want to return my order',
      'timestamp': DateTime.now().subtract(Duration(hours: 2)),
    },
    {
      'id': 'msg2',
      'conversationId': 'conv2',
      'sender': 'agent',
      'agentName': 'Sarah',
      'message': 'Please share the product images.',
      'timestamp': DateTime.now().subtract(Duration(hours: 1, minutes: 45)),
    },
  ];

  static final List<Map<String, dynamic>> _quickReplies = [
    {'text': 'Track my order', 'action': 'track_order'},
    {'text': 'Return/Refund', 'action': 'return'},
    {'text': 'Payment Issue', 'action': 'payment'},
    {'text': 'Product Inquiry', 'action': 'inquiry'},
    {'text': 'Talk to Agent', 'action': 'agent'},
  ];

  static List<Map<String, dynamic>> getConversations() => _conversations;
  static List<Map<String, dynamic>> getQuickReplies() => _quickReplies;

  static List<Map<String, dynamic>> getMessages(String conversationId) {
    return _messages
        .where((m) => m['conversationId'] == conversationId)
        .toList();
  }

  static void sendMessage(String conversationId, String message) {
    _messages.add({
      'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
      'conversationId': conversationId,
      'sender': 'user',
      'message': message,
      'timestamp': DateTime.now(),
    });

    var conv = _conversations.firstWhere((c) => c['id'] == conversationId);
    conv['lastMessage'] = message;
  }

  static String startNewConversation(String subject) {
    String convId = 'conv_${DateTime.now().millisecondsSinceEpoch}';
    _conversations.insert(0, {
      'id': convId,
      'subject': subject,
      'status': 'open',
      'createdAt': DateTime.now(),
      'lastMessage': '',
      'unread': 0,
    });
    return convId;
  }

  static int getUnreadCount() {
    return _conversations.fold(0, (sum, c) => sum + (c['unread'] as int));
  }
}

// FAQ / Help Center Service
class HelpCenterService {
  static final List<Map<String, dynamic>> _categories = [
    {'id': 'orders', 'name': 'Orders & Delivery', 'icon': '📦', 'articles': 12},
    {
      'id': 'payments',
      'name': 'Payments & Refunds',
      'icon': '💳',
      'articles': 8,
    },
    {
      'id': 'returns',
      'name': 'Returns & Exchange',
      'icon': '↩️',
      'articles': 6,
    },
    {
      'id': 'account',
      'name': 'Account & Security',
      'icon': '🔐',
      'articles': 10,
    },
    {
      'id': 'products',
      'name': 'Products & Stock',
      'icon': '🛍️',
      'articles': 5,
    },
    {
      'id': 'promotions',
      'name': 'Promotions & Coupons',
      'icon': '🎁',
      'articles': 7,
    },
  ];

  static final List<Map<String, dynamic>> _faqs = [
    {
      'id': 'faq1',
      'category': 'orders',
      'question': 'আমার অর্ডার কখন পাব?',
      'answer':
          'সাধারণত ৩-৫ কার্যদিবসের মধ্যে ডেলিভারি করা হয়। ঢাকার ভেতরে ১-২ দিন এবং ঢাকার বাইরে ৩-৫ দিন সময় লাগতে পারে।',
      'helpful': 156,
      'notHelpful': 12,
    },
    {
      'id': 'faq2',
      'category': 'orders',
      'question': 'অর্ডার ট্র্যাক করব কিভাবে?',
      'answer':
          'My Orders থেকে আপনার অর্ডার সিলেক্ট করুন এবং Track Order বাটনে ক্লিক করুন। আপনি রিয়েল-টাইম ট্র্যাকিং দেখতে পাবেন।',
      'helpful': 234,
      'notHelpful': 8,
    },
    {
      'id': 'faq3',
      'category': 'payments',
      'question': 'কোন কোন পেমেন্ট মেথড আছে?',
      'answer':
          'আমরা bKash, Nagad, Rocket, Credit/Debit Card এবং Cash on Delivery (COD) গ্রহণ করি।',
      'helpful': 189,
      'notHelpful': 5,
    },
    {
      'id': 'faq4',
      'category': 'returns',
      'question': 'রিটার্ন পলিসি কি?',
      'answer':
          'ডেলিভারি পাওয়ার ৭ দিনের মধ্যে রিটার্ন করতে পারবেন। প্রোডাক্ট অবশ্যই অব্যবহৃত এবং অরিজিনাল প্যাকেজিং সহ হতে হবে।',
      'helpful': 267,
      'notHelpful': 23,
    },
    {
      'id': 'faq5',
      'category': 'payments',
      'question': 'রিফান্ড কত দিনে পাব?',
      'answer':
          'রিফান্ড প্রসেস হতে ৫-৭ কার্যদিবস সময় লাগে। মোবাইল ব্যাংকিং এ ২-৩ দিন এবং ব্যাংক কার্ডে ৫-৭ দিন লাগতে পারে।',
      'helpful': 145,
      'notHelpful': 18,
    },
  ];

  static List<Map<String, dynamic>> getCategories() => _categories;
  static List<Map<String, dynamic>> getAllFAQs() => _faqs;

  static List<Map<String, dynamic>> getFAQsByCategory(String categoryId) {
    return _faqs.where((f) => f['category'] == categoryId).toList();
  }

  static List<Map<String, dynamic>> searchFAQs(String query) {
    String lowercaseQuery = query.toLowerCase();
    return _faqs
        .where(
          (f) =>
              (f['question'] as String).toLowerCase().contains(
                lowercaseQuery,
              ) ||
              (f['answer'] as String).toLowerCase().contains(lowercaseQuery),
        )
        .toList();
  }

  static void markHelpful(String faqId, bool helpful) {
    var faq = _faqs.firstWhere((f) => f['id'] == faqId);
    if (helpful) {
      faq['helpful'] = (faq['helpful'] as int) + 1;
    } else {
      faq['notHelpful'] = (faq['notHelpful'] as int) + 1;
    }
  }

  static List<Map<String, dynamic>> getPopularFAQs() {
    var sorted = List<Map<String, dynamic>>.from(_faqs);
    sorted.sort((a, b) => (b['helpful'] as int).compareTo(a['helpful'] as int));
    return sorted.take(5).toList();
  }
}

// Feedback / Rating Service
class FeedbackService {
  static final List<Map<String, dynamic>> _pendingFeedback = [
    {
      'id': 'fb1',
      'orderId': 'ORD-2024-001',
      'product': 'Wireless Earbuds',
      'image': 'assets/products/product1.jpg',
      'deliveredAt': DateTime.now().subtract(Duration(days: 3)),
    },
  ];

  static final List<Map<String, dynamic>> _submittedFeedback = [
    {
      'id': 'sfb1',
      'orderId': 'ORD-2024-002',
      'product': 'Smart Watch',
      'rating': 5,
      'review': 'Excellent product! Highly recommended.',
      'submittedAt': DateTime.now().subtract(Duration(days: 10)),
    },
  ];

  static List<Map<String, dynamic>> getPendingFeedback() => _pendingFeedback;
  static List<Map<String, dynamic>> getSubmittedFeedback() =>
      _submittedFeedback;

  static void submitFeedback({
    required String orderId,
    required String product,
    required int rating,
    String? review,
    List<String>? images,
  }) {
    _pendingFeedback.removeWhere((f) => f['orderId'] == orderId);
    _submittedFeedback.insert(0, {
      'id': 'sfb_${DateTime.now().millisecondsSinceEpoch}',
      'orderId': orderId,
      'product': product,
      'rating': rating,
      'review': review ?? '',
      'images': images ?? [],
      'submittedAt': DateTime.now(),
    });
  }

  static void submitDeliveryRating({
    required String orderId,
    required int deliveryRating,
    required int packagingRating,
    String? feedback,
  }) {
    // Save delivery feedback
  }

  static int getPendingCount() => _pendingFeedback.length;
}
