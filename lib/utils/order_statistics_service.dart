class OrderStatisticsService {
  static Map<String, dynamic> _statistics = {
    'totalOrders': 0,
    'totalSpent': 0.0,
    'totalSaved': 0.0,
    'completedOrders': 0,
    'pendingOrders': 0,
    'cancelledOrders': 0,
    'returnedOrders': 0,
    'averageOrderValue': 0.0,
    'mostOrderedCategory': 'Shoes',
    'loyaltyPointsEarned': 0,
    'orderHistory': <Map<String, dynamic>>[],
  };

  static Map<String, dynamic> getStatistics() => _statistics;

  static void addOrder({
    required double amount,
    required double discount,
    required String category,
    required int itemCount,
  }) {
    _statistics['totalOrders'] = (_statistics['totalOrders'] ?? 0) + 1;
    _statistics['totalSpent'] = (_statistics['totalSpent'] ?? 0.0) + amount;
    _statistics['totalSaved'] = (_statistics['totalSaved'] ?? 0.0) + discount;
    _statistics['pendingOrders'] = (_statistics['pendingOrders'] ?? 0) + 1;

    // Calculate average
    int totalOrders = _statistics['totalOrders'];
    double totalSpent = _statistics['totalSpent'];
    _statistics['averageOrderValue'] = totalOrders > 0
        ? totalSpent / totalOrders
        : 0;

    // Add to history
    (_statistics['orderHistory'] as List).add({
      'date': DateTime.now(),
      'amount': amount,
      'discount': discount,
      'category': category,
      'itemCount': itemCount,
    });
  }

  static void completeOrder() {
    if (_statistics['pendingOrders'] > 0) {
      _statistics['pendingOrders']--;
      _statistics['completedOrders']++;
    }
  }

  static void cancelOrder(double refundAmount) {
    if (_statistics['pendingOrders'] > 0) {
      _statistics['pendingOrders']--;
      _statistics['cancelledOrders']++;
      _statistics['totalSpent'] -= refundAmount;
    }
  }

  static void returnOrder(double refundAmount) {
    _statistics['returnedOrders']++;
    _statistics['totalSpent'] -= refundAmount;
  }

  static Map<String, int> getMonthlyOrders() {
    Map<String, int> monthly = {};
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    for (var month in months) {
      monthly[month] = 0;
    }

    for (var order in (_statistics['orderHistory'] as List)) {
      DateTime date = order['date'];
      String month = months[date.month - 1];
      monthly[month] = (monthly[month] ?? 0) + 1;
    }

    return monthly;
  }

  static Map<String, double> getSpendingByCategory() {
    Map<String, double> categories = {
      'Shoes': 0,
      'Electronics': 0,
      'Fashion': 0,
      'Watches': 0,
      'Furniture': 0,
    };

    for (var order in (_statistics['orderHistory'] as List)) {
      String category = order['category'] ?? 'Shoes';
      categories[category] = (categories[category] ?? 0) + order['amount'];
    }

    return categories;
  }

  // Add demo data
  static void addDemoData() {
    if (_statistics['totalOrders'] == 0) {
      _statistics = {
        'totalOrders': 15,
        'totalSpent': 45000.0,
        'totalSaved': 8500.0,
        'completedOrders': 12,
        'pendingOrders': 2,
        'cancelledOrders': 1,
        'returnedOrders': 0,
        'averageOrderValue': 3000.0,
        'mostOrderedCategory': 'Shoes',
        'loyaltyPointsEarned': 450,
        'orderHistory': [
          {
            'date': DateTime.now().subtract(Duration(days: 30)),
            'amount': 5000.0,
            'discount': 500.0,
            'category': 'Shoes',
            'itemCount': 2,
          },
          {
            'date': DateTime.now().subtract(Duration(days: 25)),
            'amount': 3500.0,
            'discount': 350.0,
            'category': 'Fashion',
            'itemCount': 1,
          },
          {
            'date': DateTime.now().subtract(Duration(days: 20)),
            'amount': 8000.0,
            'discount': 1200.0,
            'category': 'Electronics',
            'itemCount': 1,
          },
          {
            'date': DateTime.now().subtract(Duration(days: 15)),
            'amount': 2500.0,
            'discount': 250.0,
            'category': 'Shoes',
            'itemCount': 1,
          },
          {
            'date': DateTime.now().subtract(Duration(days: 10)),
            'amount': 6000.0,
            'discount': 900.0,
            'category': 'Watches',
            'itemCount': 1,
          },
          {
            'date': DateTime.now().subtract(Duration(days: 5)),
            'amount': 4000.0,
            'discount': 600.0,
            'category': 'Fashion',
            'itemCount': 2,
          },
        ],
      };
    }
  }
}
