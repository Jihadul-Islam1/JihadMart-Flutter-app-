// Wishlist Service
class WishlistService {
  static List<Map<String, dynamic>> _wishlist = [
    {
      'id': 'w1',
      'productId': 'p1',
      'name': 'Wireless Bluetooth Headphones',
      'image': 'assets/products/product1.jpg',
      'price': 5000.0,
      'originalPrice': 7000.0,
      'addedAt': DateTime.now().subtract(Duration(days: 5)),
      'inStock': true,
      'priceDropped': true,
      'priceDropAmount': 500.0,
    },
    {
      'id': 'w2',
      'productId': 'p2',
      'name': 'Smart Watch Pro',
      'image': 'assets/products/product2.jpg',
      'price': 8500.0,
      'originalPrice': 10000.0,
      'addedAt': DateTime.now().subtract(Duration(days: 3)),
      'inStock': true,
      'priceDropped': false,
      'priceDropAmount': 0.0,
    },
    {
      'id': 'w3',
      'productId': 'p3',
      'name': 'Premium Leather Bag',
      'image': 'assets/products/product3.jpg',
      'price': 4500.0,
      'originalPrice': 4500.0,
      'addedAt': DateTime.now().subtract(Duration(days: 1)),
      'inStock': false,
      'priceDropped': false,
      'priceDropAmount': 0.0,
    },
  ];

  static List<Map<String, dynamic>> _collections = [
    {
      'id': 'col1',
      'name': 'Tech Gadgets',
      'items': 5,
      'thumbnail': 'assets/products/product1.jpg',
    },
    {
      'id': 'col2',
      'name': 'Fashion',
      'items': 8,
      'thumbnail': 'assets/products/product2.jpg',
    },
    {
      'id': 'col3',
      'name': 'Home Essentials',
      'items': 3,
      'thumbnail': 'assets/products/product3.jpg',
    },
  ];

  static List<Map<String, dynamic>> getWishlist() => _wishlist;
  static List<Map<String, dynamic>> getCollections() => _collections;
  static int getWishlistCount() => _wishlist.length;

  static bool isInWishlist(String productId) {
    return _wishlist.any((w) => w['productId'] == productId);
  }

  static void addToWishlist(Map<String, dynamic> product) {
    if (!isInWishlist(product['id'])) {
      _wishlist.add({
        'id': 'w_${DateTime.now().millisecondsSinceEpoch}',
        'productId': product['id'],
        'name': product['name'],
        'image': product['image'],
        'price': product['price'],
        'originalPrice': product['originalPrice'] ?? product['price'],
        'addedAt': DateTime.now(),
        'inStock': true,
        'priceDropped': false,
        'priceDropAmount': 0.0,
      });
    }
  }

  static void removeFromWishlist(String productId) {
    _wishlist.removeWhere((w) => w['productId'] == productId);
  }

  static void toggleWishlist(Map<String, dynamic> product) {
    if (isInWishlist(product['id'])) {
      removeFromWishlist(product['id']);
    } else {
      addToWishlist(product);
    }
  }

  static void moveToCart(String wishlistId) {
    // Move item to cart and remove from wishlist
    _wishlist.removeWhere((w) => w['id'] == wishlistId);
  }

  static void moveAllToCart() {
    _wishlist.clear();
  }

  static List<Map<String, dynamic>> getPriceDroppedItems() {
    return _wishlist.where((w) => w['priceDropped'] == true).toList();
  }

  static List<Map<String, dynamic>> getBackInStockItems() {
    return _wishlist.where((w) => w['inStock'] == true).toList();
  }

  static Map<String, dynamic> createCollection(String name) {
    Map<String, dynamic> collection = {
      'id': 'col_${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'items': 0,
      'thumbnail': 'assets/logo/logo.png',
    };
    _collections.add(collection);
    return collection;
  }

  static void addToCollection(String collectionId, String productId) {
    var collection = _collections.firstWhere((c) => c['id'] == collectionId);
    collection['items'] = (collection['items'] as int) + 1;
  }
}
