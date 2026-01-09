// lib/utils/recently_viewed_service.dart
class RecentlyViewedService {
  static final List<Map<String, dynamic>> _recentlyViewed = [
    {
      'id': 'rv1',
      'product-name': 'Wireless Headphones',
      'price': 2500.0,
      'image': 'assets/products/product1.jpg',
      'rating': 4.5,
    },
    {
      'id': 'rv2',
      'product-name': 'Smart Watch',
      'price': 3500.0,
      'image': 'assets/products/product2.jpg',
      'rating': 4.2,
    },
    {
      'id': 'rv3',
      'product-name': 'Running Shoes',
      'price': 1800.0,
      'image': 'assets/products/product3.jpg',
      'rating': 4.7,
    },
  ];
  static const int _maxItems = 10;

  static List<Map<String, dynamic>> getRecentlyViewed() {
    return _recentlyViewed;
  }

  static void addProduct(Map<String, dynamic> product) {
    // Remove if already exists (to move to front)
    _recentlyViewed.removeWhere(
      (item) => item['product-name'] == product['product-name'],
    );

    // Add to front of list
    _recentlyViewed.insert(0, product);

    // Keep only max items
    if (_recentlyViewed.length > _maxItems) {
      _recentlyViewed.removeLast();
    }
  }

  static void clearAll() {
    _recentlyViewed.clear();
  }

  static int getCount() {
    return _recentlyViewed.length;
  }
}
