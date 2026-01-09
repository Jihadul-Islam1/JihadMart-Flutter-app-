// lib/utils/cart_service.dart
class CartService {
  static List<Map<String, dynamic>> _cartItems = [];
  static List<Map<String, dynamic>> _favouriteItems = [];

  // Cart methods
  static List<Map<String, dynamic>> getCartItems() {
    return _cartItems;
  }

  static void addToCart(Map<String, dynamic> product) {
    // Check if product already in cart
    int index = _cartItems.indexWhere(
      (item) => item["name"] == product["product-name"],
    );

    if (index != -1) {
      _cartItems[index]['quantity'] = (_cartItems[index]['quantity'] ?? 0) + 1;
    } else {
      var images = product["product-img"];
      if (images is! List || images.isEmpty) {
        images = ["assets/logo/logo1.png"];
      }

      _cartItems.add({
        "name": product["product-name"],
        "price": product["product-price"],
        "images": images,
        "quantity": 1,
      });
    }
  }

  static void updateCartItems(List<Map<String, dynamic>> newCartItems) {
    _cartItems = newCartItems;
  }

  static void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
    }
  }

  static void clearCart() {
    _cartItems.clear();
  }

  static int getCartItemCount() {
    return _cartItems.length;
  }

  static double getTotalPrice() {
    return _cartItems.fold(0.0, (total, item) {
      return total + ((item['price'] ?? 0) * (item['quantity'] ?? 1));
    });
  }

  // Favourite methods
  static List<Map<String, dynamic>> getFavouriteItems() {
    return _favouriteItems;
  }

  static void toggleFavourite(Map<String, dynamic> product) {
    bool isFavourite = _favouriteItems.any(
      (item) => item["name"] == product["product-name"],
    );

    if (isFavourite) {
      _favouriteItems.removeWhere(
        (item) => item["name"] == product["product-name"],
      );
    } else {
      _favouriteItems.add({
        "name": product["product-name"],
        "price": product["product-price"],
        "images": product["product-img"],
      });
    }
  }

  static bool isFavourite(Map<String, dynamic> product) {
    return _favouriteItems.any(
      (item) => item["name"] == product["product-name"],
    );
  }
}
