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
    bool alreadyInCart = _cartItems.any((item) => item["name"] == product["product-name"]);
    
    if (!alreadyInCart) {
      _cartItems.add({
        "name": product["product-name"],
        "price": product["product-price"],
        "images": product["product-img"],
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
    return _cartItems.fold(0, (total, item) {
      return total + (item['price'] * item['quantity']);
    });
  }

  // Favourite methods
  static List<Map<String, dynamic>> getFavouriteItems() {
    return _favouriteItems;
  }

  static void toggleFavourite(Map<String, dynamic> product) {
    bool isFavourite = _favouriteItems.any((item) => item["name"] == product["product-name"]);
    
    if (isFavourite) {
      _favouriteItems.removeWhere((item) => item["name"] == product["product-name"]);
    } else {
      _favouriteItems.add({
        "name": product["product-name"],
        "price": product["product-price"],
        "images": product["product-img"],
      });
    }
  }

  static bool isFavourite(Map<String, dynamic> product) {
    return _favouriteItems.any((item) => item["name"] == product["product-name"]);
  }
}