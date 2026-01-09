class CouponService {
  static List<Map<String, dynamic>> getAvailableCoupons() {
    return [
      {
        'id': 'c1',
        'code': 'WELCOME50',
        'type': 'percentage',
        'value': 50.0,
        'description': 'নতুন গ্রাহকদের জন্য ৫০% ছাড়',
        'minOrder': 500.0,
        'maxDiscount': 500.0,
        'expiresAt': DateTime.now().add(const Duration(days: 7)),
        'category': 'all',
        'isNew': true,
      },
      {
        'id': 'c2',
        'code': 'SAVE200',
        'type': 'fixed',
        'value': 200.0,
        'description': '৳২০০ ইনস্ট্যান্ট ছাড়',
        'minOrder': 1000.0,
        'maxDiscount': 200.0,
        'expiresAt': DateTime.now().add(const Duration(days: 14)),
        'category': 'all',
        'isNew': false,
      },
      {
        'id': 'c3',
        'code': 'FREEDELIVERY',
        'type': 'shipping',
        'value': 100.0,
        'description': 'ফ্রি ডেলিভারি সব প্রোডাক্টে',
        'minOrder': 800.0,
        'maxDiscount': 100.0,
        'expiresAt': DateTime.now().add(const Duration(days: 3)),
        'category': 'all',
        'isNew': true,
      },
      {
        'id': 'c4',
        'code': 'FASHION30',
        'type': 'percentage',
        'value': 30.0,
        'description': 'ফ্যাশন ক্যাটাগরিতে ৩০% ছাড়',
        'minOrder': 1500.0,
        'maxDiscount': 1000.0,
        'expiresAt': DateTime.now().add(const Duration(days: 10)),
        'category': 'fashion',
        'isNew': false,
      },
      {
        'id': 'c5',
        'code': 'ELECTRONICS500',
        'type': 'fixed',
        'value': 500.0,
        'description': 'ইলেকট্রনিক্সে ৳৫০০ ছাড়',
        'minOrder': 5000.0,
        'maxDiscount': 500.0,
        'expiresAt': DateTime.now().add(const Duration(days: 5)),
        'category': 'electronics',
        'isNew': true,
      },
      {
        'id': 'c6',
        'code': 'MEGA25',
        'type': 'percentage',
        'value': 25.0,
        'description': 'মেগা সেল! ২৫% ছাড়',
        'minOrder': 2000.0,
        'maxDiscount': 2000.0,
        'expiresAt': DateTime.now().add(const Duration(days: 2)),
        'category': 'all',
        'isNew': true,
      },
      {
        'id': 'c7',
        'code': 'GROCERY100',
        'type': 'fixed',
        'value': 100.0,
        'description': 'গ্রোসারিতে ৳১০০ ছাড়',
        'minOrder': 600.0,
        'maxDiscount': 100.0,
        'expiresAt': DateTime.now().add(const Duration(days: 30)),
        'category': 'grocery',
        'isNew': false,
      },
      {
        'id': 'c8',
        'code': 'BIJOY16',
        'type': 'percentage',
        'value': 16.0,
        'description': 'বিজয় দিবস উপলক্ষে ১৬% ছাড়',
        'minOrder': 1000.0,
        'maxDiscount': 1600.0,
        'expiresAt': DateTime.now().add(const Duration(days: 20)),
        'category': 'all',
        'isNew': true,
      },
    ];
  }

  static List<Map<String, dynamic>> getUsedCoupons() {
    return [
      {
        'code': 'SUMMER20',
        'savedAmount': 400.0,
        'usedAt': DateTime.now().subtract(const Duration(days: 3)),
      },
      {
        'code': 'FIRST100',
        'savedAmount': 100.0,
        'usedAt': DateTime.now().subtract(const Duration(days: 10)),
      },
      {
        'code': 'WEEKEND15',
        'savedAmount': 225.0,
        'usedAt': DateTime.now().subtract(const Duration(days: 15)),
      },
    ];
  }

  static Map<String, dynamic>? validateCoupon(
    String code,
    double orderTotal,
    String category,
  ) {
    final coupons = getAvailableCoupons();
    final coupon = coupons.firstWhere(
      (c) => (c['code'] as String).toUpperCase() == code.toUpperCase(),
      orElse: () => {},
    );

    if (coupon.isEmpty) {
      return {'valid': false, 'message': 'কুপন কোড পাওয়া যায়নি'};
    }

    final minOrder = coupon['minOrder'] as double;
    if (orderTotal < minOrder) {
      return {
        'valid': false,
        'message': 'ন্যূনতম অর্ডার ৳${minOrder.toStringAsFixed(0)} প্রয়োজন',
      };
    }

    final couponCategory = coupon['category'] as String;
    if (couponCategory != 'all' && couponCategory != category) {
      return {
        'valid': false,
        'message': 'এই কুপন শুধু $couponCategory ক্যাটাগরিতে প্রযোজ্য',
      };
    }

    final expiresAt = coupon['expiresAt'] as DateTime;
    if (DateTime.now().isAfter(expiresAt)) {
      return {'valid': false, 'message': 'কুপন মেয়াদ উত্তীর্ণ'};
    }

    double discount = 0;
    final type = coupon['type'] as String;
    final value = coupon['value'] as double;
    final maxDiscount = coupon['maxDiscount'] as double;

    if (type == 'percentage') {
      discount = orderTotal * (value / 100);
      if (discount > maxDiscount) {
        discount = maxDiscount;
      }
    } else if (type == 'fixed') {
      discount = value;
    } else if (type == 'shipping') {
      discount = value;
    }

    return {
      'valid': true,
      'discount': discount,
      'type': type,
      'code': coupon['code'],
    };
  }

  static double calculateDiscount(
    String code,
    double orderTotal,
    String category,
  ) {
    final result = validateCoupon(code, orderTotal, category);
    if (result != null && result['valid'] == true) {
      return result['discount'] as double;
    }
    return 0;
  }

  static List<Map<String, dynamic>> getCouponsByCategory(String category) {
    return getAvailableCoupons()
        .where((c) => c['category'] == 'all' || c['category'] == category)
        .toList();
  }

  static List<Map<String, dynamic>> getExpiringCoupons() {
    final now = DateTime.now();
    return getAvailableCoupons().where((c) {
      final expiresAt = c['expiresAt'] as DateTime;
      return expiresAt.difference(now).inDays <= 3;
    }).toList();
  }
}
