// lib/utils/review_service.dart
class ReviewService {
  static final Map<String, List<Map<String, dynamic>>> _productReviews = {
    'Wireless Headphones': [
      {
        'userName': 'Rahim',
        'userAvatar': 'assets/products/product1.jpg',
        'rating': 5.0,
        'comment': 'Excellent sound quality!',
        'date': DateTime.now().subtract(Duration(days: 2)),
      },
      {
        'userName': 'Karim',
        'userAvatar': 'assets/products/product2.jpg',
        'rating': 4.0,
        'comment': 'Good battery life.',
        'date': DateTime.now().subtract(Duration(days: 5)),
      },
    ],
  };

  static List<Map<String, dynamic>> getReviews(String productName) {
    return _productReviews[productName] ?? [];
  }

  static void addReview(String productName, Map<String, dynamic> review) {
    if (_productReviews[productName] == null) {
      _productReviews[productName] = [];
    }
    _productReviews[productName]!.insert(0, review);
  }

  static double getAverageRating(String productName) {
    final reviews = _productReviews[productName];
    if (reviews == null || reviews.isEmpty) return 0.0;

    double total = 0;
    for (var review in reviews) {
      total += review['rating'] as double;
    }
    return total / reviews.length;
  }

  static int getReviewCount(String productName) {
    return _productReviews[productName]?.length ?? 0;
  }

  static Map<int, int> getRatingDistribution(String productName) {
    Map<int, int> distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    final reviews = _productReviews[productName];

    if (reviews != null) {
      for (var review in reviews) {
        int rating = (review['rating'] as double).round();
        distribution[rating] = (distribution[rating] ?? 0) + 1;
      }
    }
    return distribution;
  }
}
