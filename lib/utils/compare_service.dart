// Product Comparison Service
class CompareService {
  static List<Map<String, dynamic>> _compareList = [];
  static const int maxCompareItems = 4;

  static List<Map<String, dynamic>> getCompareList() => _compareList;

  static bool addToCompare(Map<String, dynamic> product) {
    if (_compareList.length >= maxCompareItems) {
      return false;
    }
    if (_compareList.any((p) => p['id'] == product['id'])) {
      return false; // Already in compare
    }
    _compareList.add(product);
    return true;
  }

  static void removeFromCompare(String productId) {
    _compareList.removeWhere((p) => p['id'] == productId);
  }

  static void clearCompare() {
    _compareList.clear();
  }

  static int getCompareCount() => _compareList.length;

  static List<Map<String, dynamic>> getComparisonData() {
    if (_compareList.isEmpty) return [];

    // Generate comparison attributes
    List<String> attributes = [
      'Price',
      'Rating',
      'Reviews',
      'Brand',
      'Color Options',
      'Material',
      'Warranty',
      'Free Shipping',
      'Return Policy',
      'Stock Status',
    ];

    return attributes.map((attr) {
      Map<String, dynamic> row = {'attribute': attr};
      for (int i = 0; i < _compareList.length; i++) {
        row['product$i'] = _getAttributeValue(_compareList[i], attr);
      }
      return row;
    }).toList();
  }

  static String _getAttributeValue(
    Map<String, dynamic> product,
    String attribute,
  ) {
    switch (attribute) {
      case 'Price':
        return '৳${product['price'] ?? 'N/A'}';
      case 'Rating':
        return '${product['rating'] ?? 4.5} ⭐';
      case 'Reviews':
        return '${product['reviews'] ?? 100}+';
      case 'Brand':
        return product['brand'] ?? 'Premium';
      case 'Color Options':
        return product['colors'] ?? '3 Colors';
      case 'Material':
        return product['material'] ?? 'Premium Quality';
      case 'Warranty':
        return product['warranty'] ?? '1 Year';
      case 'Free Shipping':
        return product['freeShipping'] == true ? '✓' : '✗';
      case 'Return Policy':
        return product['returnDays'] ?? '7 Days';
      case 'Stock Status':
        return product['inStock'] == true ? 'In Stock' : 'Out of Stock';
      default:
        return 'N/A';
    }
  }

  static bool isInCompare(String productId) {
    return _compareList.any((p) => p['id'] == productId);
  }

  static List<Map<String, dynamic>> getComparisonSuggestions() {
    return [
      {
        'category': 'Smartphones',
        'items': ['iPhone 15 Pro', 'Samsung S24 Ultra'],
      },
      {
        'category': 'Laptops',
        'items': ['MacBook Pro', 'Dell XPS 15'],
      },
    ];
  }

  static void addDemoComparison() {
    _compareList.clear();
    _compareList.add({
      'id': 'p1',
      'name': 'iPhone 15 Pro',
      'price': 150000.0,
      'image': 'assets/products/product1.jpg',
      'rating': 4.8,
      'brand': 'Apple',
      'specs': {
        'মূল্য': '৳1,50,000',
        'রেটিং': '4.8',
        'ব্র্যান্ড': 'Apple',
        'স্টোরেজ': '256GB',
        'র‍্যাম': '8GB',
        'ব্যাটারি': '3274mAh',
        'ক্যামেরা': '48MP',
        'ওয়ারেন্টি': '1 Year',
      },
    });
    _compareList.add({
      'id': 'p2',
      'name': 'Samsung S24 Ultra',
      'price': 145000.0,
      'image': 'assets/products/product2.jpg',
      'rating': 4.7,
      'brand': 'Samsung',
      'specs': {
        'মূল্য': '৳1,45,000',
        'রেটিং': '4.7',
        'ব্র্যান্ড': 'Samsung',
        'স্টোরেজ': '512GB',
        'র‍্যাম': '12GB',
        'ব্যাটারি': '5000mAh',
        'ক্যামেরা': '200MP',
        'ওয়ারেন্টি': '1 Year',
      },
    });
  }
}

// Product Bundle Service
class BundleService {
  static List<Map<String, dynamic>> _bundles = [
    {
      'id': 'bundle1',
      'name': 'Complete Tech Bundle',
      'products': [
        {'name': 'Wireless Earbuds', 'price': 3000.0},
        {'name': 'Phone Case', 'price': 500.0},
        {'name': 'Screen Protector', 'price': 300.0},
        {'name': 'Fast Charger', 'price': 1200.0},
      ],
      'originalPrice': 5000.0,
      'bundlePrice': 3999.0,
      'discount': '20%',
      'image': 'assets/products/product1.jpg',
    },
    {
      'id': 'bundle2',
      'name': 'Home Office Starter',
      'products': [
        {'name': 'Desk Lamp', 'price': 1500.0},
        {'name': 'Mouse Pad', 'price': 400.0},
        {'name': 'USB Hub', 'price': 800.0},
        {'name': 'Webcam', 'price': 2500.0},
      ],
      'originalPrice': 5200.0,
      'bundlePrice': 3999.0,
      'discount': '23%',
      'image': 'assets/products/product2.jpg',
    },
    {
      'id': 'bundle3',
      'name': 'Fitness Essentials',
      'products': [
        {'name': 'Fitness Band', 'price': 2000.0},
        {'name': 'Water Bottle', 'price': 500.0},
        {'name': 'Yoga Mat', 'price': 800.0},
        {'name': 'Resistance Bands', 'price': 600.0},
      ],
      'originalPrice': 3900.0,
      'bundlePrice': 2999.0,
      'discount': '23%',
      'image': 'assets/products/product3.jpg',
    },
  ];

  static List<Map<String, dynamic>> _customBundles = [];

  static List<Map<String, dynamic>> getBundles() => _bundles;
  static List<Map<String, dynamic>> getCustomBundles() => _customBundles;

  static Map<String, dynamic> createCustomBundle(
    String name,
    List<Map<String, dynamic>> products,
  ) {
    double total = products.fold(0, (sum, p) => sum + (p['price'] as double));
    double discount = total * 0.15; // 15% bundle discount

    Map<String, dynamic> bundle = {
      'id': 'custom_${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'products': products,
      'originalPrice': total,
      'bundlePrice': total - discount,
      'discount': '15%',
      'isCustom': true,
    };

    _customBundles.add(bundle);
    return bundle;
  }

  static double calculateSavings(String bundleId) {
    var bundle = _bundles.firstWhere(
      (b) => b['id'] == bundleId,
      orElse: () => {},
    );
    if (bundle.isEmpty) {
      bundle = _customBundles.firstWhere(
        (b) => b['id'] == bundleId,
        orElse: () => {},
      );
    }
    if (bundle.isEmpty) return 0;
    return (bundle['originalPrice'] as double) -
        (bundle['bundlePrice'] as double);
  }
}
