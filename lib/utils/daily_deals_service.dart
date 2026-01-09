class DailyDealsService {
  static List<Map<String, dynamic>> _todaysDeals = [];
  static DateTime? _lastUpdated;

  static List<Map<String, dynamic>> getTodaysDeals() {
    _checkAndRefreshDeals();
    return _todaysDeals;
  }

  static void _checkAndRefreshDeals() {
    DateTime now = DateTime.now();
    if (_lastUpdated == null ||
        now.day != _lastUpdated!.day ||
        _todaysDeals.isEmpty) {
      _generateDailyDeals();
      _lastUpdated = now;
    }
  }

  static void _generateDailyDeals() {
    _todaysDeals = [
      {
        'id': '1',
        'title': 'আজকের সেরা ডিল! 🔥',
        'subtitle': 'Nike Air Max 50% ছাড়!',
        'product-name': 'Nike Air Max Pro',
        'product-description':
            'Premium running shoes with advanced cushioning.',
        'original-price': 15000.0,
        'deal-price': 7500.0,
        'discount': 50,
        'product-img': ['assets/products/product1.jpg'],
        'endsIn': DateTime.now().add(Duration(hours: 8)),
        'stock': 5,
        'sold': 23,
        'dealType': 'flash',
      },
      {
        'id': '2',
        'title': 'সীমিত সময়!',
        'subtitle': 'Adidas Ultraboost - শুধু আজ!',
        'product-name': 'Adidas Ultraboost 22',
        'product-description': 'Ultimate comfort for marathon runners.',
        'original-price': 22000.0,
        'deal-price': 13200.0,
        'discount': 40,
        'product-img': ['assets/products/product2.jpg'],
        'endsIn': DateTime.now().add(Duration(hours: 12)),
        'stock': 8,
        'sold': 15,
        'dealType': 'daily',
      },
      {
        'id': '3',
        'title': 'একসাথে কিনুন সেভ করুন!',
        'subtitle': '২টি কিনলে ৩০% ছাড়',
        'product-name': 'Puma RS-X Bundle',
        'product-description': 'Buy 2 get 30% off on RS-X collection.',
        'original-price': 18000.0,
        'deal-price': 12600.0,
        'discount': 30,
        'product-img': ['assets/products/product3.jpg'],
        'endsIn': DateTime.now().add(Duration(hours: 24)),
        'stock': 12,
        'sold': 8,
        'dealType': 'bundle',
      },
      {
        'id': '4',
        'title': 'নতুন ইউজার অফার! 🎉',
        'subtitle': 'প্রথম অর্ডারে ২৫% ছাড়',
        'product-name': 'Reebok Classic Leather',
        'product-description': 'Timeless classic for everyday style.',
        'original-price': 10000.0,
        'deal-price': 7500.0,
        'discount': 25,
        'product-img': ['assets/products/product4.jpg'],
        'endsIn': DateTime.now().add(Duration(hours: 48)),
        'stock': 20,
        'sold': 5,
        'dealType': 'new_user',
      },
      {
        'id': '5',
        'title': 'Weekend Special! 🌟',
        'subtitle': 'সব Electronics-এ ২০% ছাড়',
        'product-name': 'Smart Watch Pro',
        'product-description':
            'Advanced fitness tracking with heart rate monitor.',
        'original-price': 8000.0,
        'deal-price': 6400.0,
        'discount': 20,
        'product-img': ['assets/products/product5.jpg'],
        'endsIn': DateTime.now().add(Duration(hours: 36)),
        'stock': 15,
        'sold': 12,
        'dealType': 'weekend',
      },
    ];
  }

  static Map<String, dynamic>? getDealOfTheDay() {
    _checkAndRefreshDeals();
    if (_todaysDeals.isNotEmpty) {
      // Return the best deal (highest discount)
      return _todaysDeals.reduce(
        (a, b) => (a['discount'] ?? 0) > (b['discount'] ?? 0) ? a : b,
      );
    }
    return null;
  }

  static List<Map<String, dynamic>> getDealsByType(String type) {
    return _todaysDeals.where((deal) => deal['dealType'] == type).toList();
  }

  static int getRemainingStock(String dealId) {
    var deal = _todaysDeals.firstWhere(
      (d) => d['id'] == dealId,
      orElse: () => {},
    );
    return deal['stock'] ?? 0;
  }

  static Duration getTimeRemaining(String dealId) {
    var deal = _todaysDeals.firstWhere(
      (d) => d['id'] == dealId,
      orElse: () => {},
    );
    if (deal.isNotEmpty && deal['endsIn'] != null) {
      return (deal['endsIn'] as DateTime).difference(DateTime.now());
    }
    return Duration.zero;
  }

  static void claimDeal(String dealId) {
    int index = _todaysDeals.indexWhere((d) => d['id'] == dealId);
    if (index != -1 && _todaysDeals[index]['stock'] > 0) {
      _todaysDeals[index]['stock']--;
      _todaysDeals[index]['sold']++;
    }
  }
}
