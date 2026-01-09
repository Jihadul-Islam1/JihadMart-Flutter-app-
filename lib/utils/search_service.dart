// Voice Search Service
class VoiceSearchService {
  static bool _isListening = false;
  static List<String> _recentVoiceSearches = [
    'লাল টি-শার্ট',
    'ওয়্যারলেস ইয়ারবাড',
    'স্মার্ট ওয়াচ',
    'মোবাইল ফোন কভার',
  ];

  static List<Map<String, dynamic>> _voiceCommands = [
    {
      'command': 'সার্চ করো',
      'action': 'search',
      'example': '"সার্চ করো নীল জুতা"',
    },
    {
      'command': 'কার্টে যোগ করো',
      'action': 'add_to_cart',
      'example': '"কার্টে যোগ করো"',
    },
    {
      'command': 'অর্ডার দেখাও',
      'action': 'show_orders',
      'example': '"আমার অর্ডার দেখাও"',
    },
    {
      'command': 'ক্যাটাগরি খোলো',
      'action': 'open_category',
      'example': '"ইলেকট্রনিক্স খোলো"',
    },
    {
      'command': 'কার্ট দেখাও',
      'action': 'show_cart',
      'example': '"কার্ট দেখাও"',
    },
  ];

  static bool isListening() => _isListening;
  static List<String> getRecentVoiceSearches() => _recentVoiceSearches;
  static List<Map<String, dynamic>> getVoiceCommands() => _voiceCommands;

  static void startListening() {
    _isListening = true;
  }

  static void stopListening() {
    _isListening = false;
  }

  static Map<String, dynamic> processVoiceInput(String input) {
    // Simple command parsing
    String lowercaseInput = input.toLowerCase();

    if (lowercaseInput.contains('সার্চ') || lowercaseInput.contains('খুঁজো')) {
      String query = input.replaceAll(RegExp(r'সার্চ করো|খুঁজো'), '').trim();
      _recentVoiceSearches.insert(0, query);
      return {'action': 'search', 'query': query};
    }

    if (lowercaseInput.contains('কার্ট') && lowercaseInput.contains('দেখাও')) {
      return {'action': 'navigate', 'destination': 'cart'};
    }

    if (lowercaseInput.contains('অর্ডার') && lowercaseInput.contains('দেখাও')) {
      return {'action': 'navigate', 'destination': 'orders'};
    }

    // Default: treat as search query
    _recentVoiceSearches.insert(0, input);
    return {'action': 'search', 'query': input};
  }

  static void clearHistory() {
    _recentVoiceSearches.clear();
  }
}

// AR Try-On Service (Simulated)
class ARService {
  static bool _isSupported = true;
  static List<String> _supportedCategories = [
    'Glasses',
    'Watches',
    'Shoes',
    'Hats',
    'Jewelry',
    'Makeup',
    'Clothing',
  ];

  static List<Map<String, dynamic>> _triedProducts = [
    {
      'id': 'ar1',
      'name': 'Ray-Ban Aviator',
      'category': 'Glasses',
      'image': 'assets/products/product1.jpg',
      'triedAt': DateTime.now().subtract(Duration(days: 2)),
      'liked': true,
    },
    {
      'id': 'ar2',
      'name': 'Smart Watch Pro',
      'category': 'Watches',
      'image': 'assets/products/product2.jpg',
      'triedAt': DateTime.now().subtract(Duration(days: 1)),
      'liked': false,
    },
  ];

  static bool isSupported() => _isSupported;
  static List<String> getSupportedCategories() => _supportedCategories;
  static List<Map<String, dynamic>> getTriedProducts() => _triedProducts;

  static bool canTryOn(String category) {
    return _supportedCategories.contains(category);
  }

  static void saveTryOn(Map<String, dynamic> product, bool liked) {
    _triedProducts.insert(0, {
      'id': 'ar_${DateTime.now().millisecondsSinceEpoch}',
      'name': product['name'],
      'category': product['category'],
      'image': product['image'],
      'triedAt': DateTime.now(),
      'liked': liked,
    });
  }

  static List<Map<String, dynamic>> getLikedProducts() {
    return _triedProducts.where((p) => p['liked'] == true).toList();
  }

  static void clearHistory() {
    _triedProducts.clear();
  }
}

// Image Search Service
class ImageSearchService {
  static List<Map<String, dynamic>> _searchHistory = [
    {
      'id': 'img1',
      'imagePath': 'assets/products/product1.jpg',
      'searchedAt': DateTime.now().subtract(Duration(days: 1)),
      'resultsCount': 15,
    },
  ];

  static List<Map<String, dynamic>> getSearchHistory() => _searchHistory;

  static Future<List<Map<String, dynamic>>> searchByImage(
    String imagePath,
  ) async {
    // Simulate image search results
    await Future.delayed(Duration(seconds: 2));

    _searchHistory.insert(0, {
      'id': 'img_${DateTime.now().millisecondsSinceEpoch}',
      'imagePath': imagePath,
      'searchedAt': DateTime.now(),
      'resultsCount': 12,
    });

    return [
      {
        'id': 'result1',
        'name': 'Similar Product 1',
        'price': 2500.0,
        'image': 'assets/products/product1.jpg',
        'similarity': 95,
      },
      {
        'id': 'result2',
        'name': 'Similar Product 2',
        'price': 2800.0,
        'image': 'assets/products/product2.jpg',
        'similarity': 87,
      },
      {
        'id': 'result3',
        'name': 'Similar Product 3',
        'price': 2200.0,
        'image': 'assets/products/product3.jpg',
        'similarity': 82,
      },
    ];
  }

  static void clearHistory() {
    _searchHistory.clear();
  }
}
