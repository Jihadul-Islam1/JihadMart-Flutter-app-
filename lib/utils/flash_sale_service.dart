// Flash Sale / Time-Limited Deals Service
class FlashSaleService {
  static final List<Map<String, dynamic>> _flashSales = [
    {
      'id': 'flash1',
      'name': 'Mega Flash Sale 🔥',
      'startTime': DateTime.now().subtract(Duration(hours: 2)),
      'endTime': DateTime.now().add(Duration(hours: 4)),
      'isActive': true,
      'totalSold': 1234,
      'products': [
        {
          'id': 'fp1',
          'name': 'Nike Air Max Pro',
          'image': 'assets/products/product1.jpg',
          'originalPrice': 5000.0,
          'salePrice': 2499.0,
          'discount': '50%',
          'stock': 100,
          'sold': 87,
        },
        {
          'id': 'fp2',
          'name': 'Adidas Ultraboost',
          'image': 'assets/products/product2.jpg',
          'originalPrice': 8000.0,
          'salePrice': 3999.0,
          'discount': '50%',
          'stock': 50,
          'sold': 48,
        },
        {
          'id': 'fp3',
          'name': 'Puma RS-X',
          'image': 'assets/products/product3.jpg',
          'originalPrice': 2500.0,
          'salePrice': 1299.0,
          'discount': '48%',
          'stock': 200,
          'sold': 156,
        },
        {
          'id': 'fp4',
          'name': 'Reebok Classic',
          'image': 'assets/products/product4.jpg',
          'originalPrice': 4500.0,
          'salePrice': 2250.0,
          'discount': '50%',
          'stock': 80,
          'sold': 12,
        },
      ],
    },
  ];

  static final List<Map<String, dynamic>> _upcomingFlashSales = [
    {
      'id': 'flash2',
      'name': 'Midnight Madness 🌙',
      'startTime': DateTime.now().add(Duration(hours: 10)),
      'endTime': DateTime.now().add(Duration(hours: 14)),
      'productCount': 50,
      'maxDiscount': '70%',
    },
    {
      'id': 'flash3',
      'name': 'Weekend Special 🎉',
      'startTime': DateTime.now().add(Duration(days: 2)),
      'endTime': DateTime.now().add(Duration(days: 2, hours: 12)),
      'productCount': 100,
      'maxDiscount': '60%',
    },
  ];

  static List<Map<String, dynamic>> getActiveFlashSales() =>
      _flashSales.where((s) => s['isActive'] == true).toList();

  static List<Map<String, dynamic>> getUpcomingFlashSales() =>
      _upcomingFlashSales;

  static Duration getRemainingTime(String saleId) {
    var sale = _flashSales.firstWhere(
      (s) => s['id'] == saleId,
      orElse: () => {},
    );
    if (sale.isEmpty) return Duration.zero;
    return (sale['endTime'] as DateTime).difference(DateTime.now());
  }

  static double getStockProgress(Map<String, dynamic> product) {
    return (product['sold'] as int) / (product['stock'] as int);
  }

  static bool setReminder(String saleId) {
    return true;
  }
}

// Coupon / Promo Code Service (Enhanced)
class CouponService {
  static final List<Map<String, dynamic>> _availableCoupons = [
    {
      'code': 'WELCOME50',
      'type': 'percentage',
      'value': 50.0,
      'maxDiscount': 500.0,
      'minOrder': 1000.0,
      'description': 'নতুন ব্যবহারকারীদের জন্য ৫০% ছাড়',
      'expiresAt': DateTime.now().add(Duration(days: 30)),
      'usageLimit': 1,
      'categories': ['all'],
      'isNew': true,
    },
    {
      'code': 'SAVE100',
      'type': 'fixed',
      'value': 100.0,
      'maxDiscount': 100.0,
      'minOrder': 500.0,
      'description': '৳৫০০+ অর্ডারে ৳১০০ ছাড়',
      'expiresAt': DateTime.now().add(Duration(days: 15)),
      'usageLimit': 3,
      'categories': ['all'],
      'isNew': false,
    },
    {
      'code': 'FLASH20',
      'type': 'percentage',
      'value': 20.0,
      'maxDiscount': 300.0,
      'minOrder': 800.0,
      'description': 'ইলেকট্রনিক্স এ ২০% ছাড়',
      'expiresAt': DateTime.now().add(Duration(days: 7)),
      'usageLimit': 2,
      'categories': ['electronics'],
      'isNew': false,
    },
    {
      'code': 'FREESHIP',
      'type': 'shipping',
      'value': 100.0,
      'maxDiscount': 100.0,
      'minOrder': 500.0,
      'description': 'ফ্রি ডেলিভারি',
      'expiresAt': DateTime.now().add(Duration(days: 10)),
      'usageLimit': 5,
      'categories': ['all'],
      'isNew': true,
    },
    {
      'code': 'FASHION30',
      'type': 'percentage',
      'value': 30.0,
      'maxDiscount': 500.0,
      'minOrder': 1500.0,
      'description': 'ফ্যাশন আইটেমে ৩০% ছাড়',
      'expiresAt': DateTime.now().add(Duration(days: 5)),
      'usageLimit': 1,
      'categories': ['fashion'],
      'isNew': true,
    },
  ];

  static final List<Map<String, dynamic>> _usedCoupons = [
    {
      'code': 'NEWUSER25',
      'usedAt': DateTime.now().subtract(Duration(days: 10)),
      'savedAmount': 250.0,
    },
  ];

  static List<Map<String, dynamic>> getAvailableCoupons() => _availableCoupons;
  static List<Map<String, dynamic>> getUsedCoupons() => _usedCoupons;

  static Map<String, dynamic>? validateCoupon(
    String code,
    double orderTotal,
    String category,
  ) {
    var coupon = _availableCoupons.firstWhere(
      (c) => c['code'].toString().toUpperCase() == code.toUpperCase(),
      orElse: () => {},
    );

    if (coupon.isEmpty) {
      return {'valid': false, 'message': 'কুপন পাওয়া যায়নি'};
    }

    if ((coupon['expiresAt'] as DateTime).isBefore(DateTime.now())) {
      return {'valid': false, 'message': 'কুপনের মেয়াদ শেষ'};
    }

    if (orderTotal < (coupon['minOrder'] as double)) {
      return {
        'valid': false,
        'message': 'ন্যূনতম অর্ডার ৳${coupon['minOrder']}',
      };
    }

    List<String> categories = coupon['categories'] as List<String>;
    if (!categories.contains('all') && !categories.contains(category)) {
      return {'valid': false, 'message': 'এই ক্যাটাগরিতে প্রযোজ্য নয়'};
    }

    double discount = 0;
    if (coupon['type'] == 'percentage') {
      discount = orderTotal * (coupon['value'] as double) / 100;
      if (discount > (coupon['maxDiscount'] as double)) {
        discount = coupon['maxDiscount'] as double;
      }
    } else {
      discount = coupon['value'] as double;
    }

    return {'valid': true, 'discount': discount, 'coupon': coupon};
  }

  static void applyCoupon(String code, double savedAmount) {
    _usedCoupons.add({
      'code': code,
      'usedAt': DateTime.now(),
      'savedAmount': savedAmount,
    });
  }

  static List<Map<String, dynamic>> getRecommendedCoupons(
    double orderTotal,
    String category,
  ) {
    return _availableCoupons.where((c) {
      List<String> categories = c['categories'] as List<String>;
      return orderTotal >= (c['minOrder'] as double) &&
          (categories.contains('all') || categories.contains(category));
    }).toList();
  }
}
