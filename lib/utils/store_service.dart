// Store Locator / Pickup Service
class StoreLocatorService {
  static final List<Map<String, dynamic>> _stores = [
    {
      'id': 'store1',
      'name': 'Jihad Store - Gulshan',
      'address': 'Road 11, Block C, Gulshan-2, Dhaka',
      'phone': '+880 1712345678',
      'lat': 23.7925,
      'lng': 90.4078,
      'distance': 2.5,
      'rating': 4.8,
      'reviews': 156,
      'isOpen': true,
      'openHours': '10:00 AM - 10:00 PM',
      'hasPickup': true,
      'hasTryRoom': true,
      'hasParking': true,
      'image': 'assets/products/product1.jpg',
    },
    {
      'id': 'store2',
      'name': 'Jihad Store - Dhanmondi',
      'address': 'Road 27, Dhanmondi, Dhaka',
      'phone': '+880 1812345678',
      'lat': 23.7461,
      'lng': 90.3742,
      'distance': 4.2,
      'rating': 4.6,
      'reviews': 98,
      'isOpen': true,
      'openHours': '10:00 AM - 9:00 PM',
      'hasPickup': true,
      'hasTryRoom': false,
      'hasParking': true,
      'image': 'assets/products/product2.jpg',
    },
    {
      'id': 'store3',
      'name': 'Jihad Store - Bashundhara',
      'address': 'Block D, Bashundhara R/A, Dhaka',
      'phone': '+880 1912345678',
      'lat': 23.8103,
      'lng': 90.4125,
      'distance': 6.8,
      'rating': 4.5,
      'reviews': 72,
      'isOpen': false,
      'openHours': '11:00 AM - 8:00 PM',
      'hasPickup': true,
      'hasTryRoom': true,
      'hasParking': false,
      'image': 'assets/products/product3.jpg',
    },
    {
      'id': 'store4',
      'name': 'Jihad Store - Uttara',
      'address': 'Sector 7, Uttara, Dhaka',
      'phone': '+880 1612345678',
      'lat': 23.8759,
      'lng': 90.3795,
      'distance': 10.5,
      'rating': 4.7,
      'reviews': 134,
      'isOpen': true,
      'openHours': '10:00 AM - 9:30 PM',
      'hasPickup': true,
      'hasTryRoom': true,
      'hasParking': true,
      'image': 'assets/products/product4.jpg',
    },
  ];

  static final List<Map<String, dynamic>> _pickupOrders = [
    {
      'id': 'pickup1',
      'orderId': 'ORD-2024-001',
      'store': 'Jihad Store - Gulshan',
      'pickupCode': 'PKP-892456',
      'status': 'ready',
      'expiresAt': DateTime.now().add(Duration(days: 3)),
    },
  ];

  static List<Map<String, dynamic>> getStores() => _stores;
  static List<Map<String, dynamic>> getNearbyStores() {
    var sorted = List<Map<String, dynamic>>.from(_stores);
    sorted.sort(
      (a, b) => (a['distance'] as double).compareTo(b['distance'] as double),
    );
    return sorted;
  }

  static List<Map<String, dynamic>> getPickupOrders() => _pickupOrders;

  static List<Map<String, dynamic>> getOpenStores() {
    return _stores.where((s) => s['isOpen'] == true).toList();
  }

  static List<Map<String, dynamic>> getStoresWithPickup() {
    return _stores.where((s) => s['hasPickup'] == true).toList();
  }

  static Map<String, dynamic>? getNearestStore() {
    var stores = getNearbyStores();
    return stores.isNotEmpty ? stores.first : null;
  }

  static bool schedulePickup(
    String orderId,
    String storeId,
    DateTime pickupTime,
  ) {
    _pickupOrders.add({
      'id': 'pickup_${DateTime.now().millisecondsSinceEpoch}',
      'orderId': orderId,
      'store': _stores.firstWhere((s) => s['id'] == storeId)['name'],
      'pickupCode': 'PKP-${DateTime.now().millisecond}${DateTime.now().second}',
      'status': 'scheduled',
      'scheduledAt': pickupTime,
      'expiresAt': pickupTime.add(Duration(days: 3)),
    });
    return true;
  }
}

// QR Code / Barcode Scanner Service
class ScannerService {
  static final List<Map<String, dynamic>> _scanHistory = [
    {
      'id': 'scan1',
      'type': 'product',
      'code': 'PROD-2024-001',
      'productName': 'Wireless Earbuds Pro',
      'price': 3500.0,
      'scannedAt': DateTime.now().subtract(Duration(days: 1)),
    },
    {
      'id': 'scan2',
      'type': 'coupon',
      'code': 'SAVE50',
      'discount': '50% OFF',
      'scannedAt': DateTime.now().subtract(Duration(days: 2)),
    },
  ];

  static List<Map<String, dynamic>> getScanHistory() => _scanHistory;

  static Map<String, dynamic> scanProduct(String code) {
    // Simulate product lookup
    Map<String, dynamic> result = {
      'type': 'product',
      'code': code,
      'productName': 'Product ${code.substring(code.length - 3)}',
      'price': 2500.0,
      'inStock': true,
      'scannedAt': DateTime.now(),
    };
    _scanHistory.insert(0, {
      'id': 'scan_${DateTime.now().millisecondsSinceEpoch}',
      ...result,
    });
    return result;
  }

  static Map<String, dynamic> scanCoupon(String code) {
    // Simulate coupon validation
    Map<String, dynamic> result = {
      'type': 'coupon',
      'code': code,
      'valid': true,
      'discount': '20% OFF',
      'minOrder': 500.0,
      'expiresAt': DateTime.now().add(Duration(days: 30)),
      'scannedAt': DateTime.now(),
    };
    _scanHistory.insert(0, {
      'id': 'scan_${DateTime.now().millisecondsSinceEpoch}',
      ...result,
    });
    return result;
  }

  static Map<String, dynamic> scanReceipt(String code) {
    // Simulate receipt lookup for returns
    return {
      'type': 'receipt',
      'orderId': code,
      'orderDate': DateTime.now().subtract(Duration(days: 5)),
      'total': 5500.0,
      'items': 3,
      'returnable': true,
    };
  }

  static void clearHistory() {
    _scanHistory.clear();
  }
}
