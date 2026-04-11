class PriceAlertService {
  static final List<Map<String, dynamic>> _priceAlerts = [];
  static final List<Map<String, dynamic>> _triggeredAlerts = [];

  static List<Map<String, dynamic>> getPriceAlerts() => _priceAlerts;
  static List<Map<String, dynamic>> getTriggeredAlerts() => _triggeredAlerts;

  static void addPriceAlert({
    required String productName,
    required double currentPrice,
    required double targetPrice,
    required List<dynamic> productImages,
  }) {
    // Check if alert already exists for this product
    bool exists = _priceAlerts.any(
      (alert) => alert['productName'] == productName,
    );

    if (!exists) {
      _priceAlerts.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'productName': productName,
        'currentPrice': currentPrice,
        'targetPrice': targetPrice,
        'productImages': productImages,
        'createdAt': DateTime.now(),
        'isTriggered': false,
      });
    }
  }

  static void removePriceAlert(String id) {
    _priceAlerts.removeWhere((alert) => alert['id'] == id);
  }

  static void checkPriceDrops(List<Map<String, dynamic>> products) {
    for (var alert in _priceAlerts) {
      for (var product in products) {
        if (product['product-name'] == alert['productName']) {
          double newPrice = (product['product-price'] ?? 0).toDouble();
          if (newPrice <= alert['targetPrice'] && !alert['isTriggered']) {
            alert['isTriggered'] = true;
            alert['newPrice'] = newPrice;
            alert['droppedAt'] = DateTime.now();
            _triggeredAlerts.add(Map.from(alert));
          }
        }
      }
    }
  }

  static bool hasAlert(String productName) {
    return _priceAlerts.any((alert) => alert['productName'] == productName);
  }

  static int getAlertCount() => _priceAlerts.length;
  static int getTriggeredCount() => _triggeredAlerts.length;

  static void clearTriggeredAlerts() {
    _triggeredAlerts.clear();
  }

  // Demo alerts
  static void addDemoAlerts() {
    if (_priceAlerts.isEmpty) {
      addPriceAlert(
        productName: "Nike Air Max",
        currentPrice: 12000,
        targetPrice: 10000,
        productImages: ["assets/products/product1.jpg"],
      );
      addPriceAlert(
        productName: "Adidas Ultraboost",
        currentPrice: 18000,
        targetPrice: 15000,
        productImages: ["assets/products/product2.jpg"],
      );
    }
  }
}
