// Group Buy / Bundle Deals Service
class GroupBuyService {
  static List<Map<String, dynamic>> _groupDeals = [
    {
      'id': 'group1',
      'product': 'Smart Watch Pro',
      'image': 'assets/products/product5.jpg',
      'originalPrice': 5000.0,
      'groupPrice': 2999.0,
      'minBuyers': 50,
      'currentBuyers': 38,
      'endTime': DateTime.now().add(Duration(days: 3)),
      'discount': '40%',
    },
    {
      'id': 'group2',
      'product': 'Running Shoes',
      'image': 'assets/products/product6.jpg',
      'originalPrice': 3500.0,
      'groupPrice': 1999.0,
      'minBuyers': 100,
      'currentBuyers': 87,
      'endTime': DateTime.now().add(Duration(days: 1)),
      'discount': '43%',
    },
    {
      'id': 'group3',
      'product': 'Leather Bag',
      'image': 'assets/products/product7.jpg',
      'originalPrice': 8000.0,
      'groupPrice': 4500.0,
      'minBuyers': 30,
      'currentBuyers': 28,
      'endTime': DateTime.now().add(Duration(hours: 12)),
      'discount': '44%',
    },
  ];

  static List<Map<String, dynamic>> getGroupDeals() => _groupDeals;

  static bool joinGroup(String dealId) {
    var deal = _groupDeals.firstWhere((d) => d['id'] == dealId);
    if (deal['currentBuyers'] < deal['minBuyers']) {
      deal['currentBuyers'] = (deal['currentBuyers'] as int) + 1;
      return true;
    }
    return false;
  }

  static int getRemainingSpots(String dealId) {
    var deal = _groupDeals.firstWhere((d) => d['id'] == dealId);
    return (deal['minBuyers'] as int) - (deal['currentBuyers'] as int);
  }

  static double getProgress(String dealId) {
    var deal = _groupDeals.firstWhere((d) => d['id'] == dealId);
    return (deal['currentBuyers'] as int) / (deal['minBuyers'] as int);
  }
}
