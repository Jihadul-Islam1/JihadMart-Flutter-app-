import 'package:flutter/material.dart';

// Brand Service
class BrandService {
  static List<Map<String, dynamic>> _brands = [
    {
      'id': 'brand1',
      'name': 'Apple',
      'logo': 'assets/products/product1.jpg',
      'icon': Icons.apple,
      'color': Colors.black,
      'category': 'electronics',
      'isVerified': true,
      'followers': 125000,
      'products': 156,
      'rating': 4.9,
      'isFollowing': true,
      'productImages': [
        'assets/products/product1.jpg',
        'assets/products/product2.jpg',
        'assets/products/product3.jpg',
      ],
    },
    {
      'id': 'brand2',
      'name': 'Samsung',
      'logo': 'assets/products/product2.jpg',
      'icon': Icons.phone_android,
      'color': Colors.blue,
      'category': 'electronics',
      'isVerified': true,
      'followers': 98000,
      'products': 234,
      'rating': 4.7,
      'isFollowing': false,
      'productImages': [
        'assets/products/product4.jpg',
        'assets/products/product5.jpg',
        'assets/products/product6.jpg',
      ],
    },
    {
      'id': 'brand3',
      'name': 'Nike',
      'logo': 'assets/products/product3.jpg',
      'icon': Icons.check,
      'color': Colors.black,
      'category': 'fashion',
      'isVerified': true,
      'followers': 156000,
      'products': 450,
      'rating': 4.8,
      'isFollowing': true,
      'productImages': [
        'assets/products/product1.jpg',
        'assets/products/product3.jpg',
        'assets/products/product5.jpg',
      ],
    },
    {
      'id': 'brand4',
      'name': 'Adidas',
      'logo': 'assets/products/product4.jpg',
      'icon': Icons.change_history,
      'color': Colors.black,
      'category': 'fashion',
      'isVerified': true,
      'followers': 134000,
      'products': 380,
      'rating': 4.7,
      'isFollowing': false,
      'productImages': [
        'assets/products/product2.jpg',
        'assets/products/product4.jpg',
        'assets/products/product6.jpg',
      ],
    },
    {
      'id': 'brand5',
      'name': 'Sony',
      'logo': 'assets/products/product5.jpg',
      'icon': Icons.surround_sound,
      'color': Colors.indigo,
      'category': 'electronics',
      'isVerified': true,
      'followers': 67000,
      'products': 89,
      'rating': 4.6,
      'isFollowing': false,
      'productImages': [
        'assets/products/product1.jpg',
        'assets/products/product5.jpg',
        'assets/products/product3.jpg',
      ],
    },
    {
      'id': 'brand6',
      'name': 'Xiaomi',
      'logo': 'assets/products/product6.jpg',
      'icon': Icons.phone_android,
      'color': Colors.orange,
      'category': 'electronics',
      'isVerified': true,
      'followers': 89000,
      'products': 312,
      'rating': 4.5,
      'isFollowing': true,
      'productImages': [
        'assets/products/product2.jpg',
        'assets/products/product6.jpg',
        'assets/products/product4.jpg',
      ],
    },
  ];

  static List<Map<String, dynamic>> getAllBrands() => _brands;

  static bool isFollowingBrand(String brandId) {
    var brand = _brands.firstWhere((b) => b['id'] == brandId, orElse: () => {});
    return brand.isNotEmpty && brand['isFollowing'] == true;
  }

  static List<Map<String, dynamic>> getFollowedBrands() {
    return _brands.where((b) => b['isFollowing'] == true).toList();
  }

  static List<Map<String, dynamic>> getTopBrands() {
    var sorted = List<Map<String, dynamic>>.from(_brands);
    sorted.sort(
      (a, b) => (b['followers'] as int).compareTo(a['followers'] as int),
    );
    return sorted.take(6).toList();
  }

  static void followBrand(String brandId) {
    var brand = _brands.firstWhere((b) => b['id'] == brandId);
    brand['isFollowing'] = true;
    brand['followers'] = (brand['followers'] as int) + 1;
  }

  static void unfollowBrand(String brandId) {
    var brand = _brands.firstWhere((b) => b['id'] == brandId);
    brand['isFollowing'] = false;
    brand['followers'] = (brand['followers'] as int) - 1;
  }

  static List<Map<String, dynamic>> searchBrands(String query) {
    return _brands
        .where(
          (b) =>
              (b['name'] as String).toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}

// Seller / Vendor Service
class SellerService {
  static List<Map<String, dynamic>> _sellers = [
    {
      'id': 'seller1',
      'name': 'Tech Hub BD',
      'avatar': 'T',
      'isVerified': true,
      'rating': 4.8,
      'totalReviews': 1256,
      'totalProducts': 89,
      'followers': 12500,
      'responseRate': 98,
      'shipOnTime': 95,
      'joinedDate': DateTime(2020, 3, 15),
      'isFollowing': false,
      'productImages': [
        'assets/products/product1.jpg',
        'assets/products/product2.jpg',
        'assets/products/product3.jpg',
      ],
    },
    {
      'id': 'seller2',
      'name': 'Fashion Point',
      'avatar': 'F',
      'isVerified': true,
      'rating': 4.6,
      'totalReviews': 892,
      'totalProducts': 234,
      'followers': 8900,
      'responseRate': 95,
      'shipOnTime': 92,
      'joinedDate': DateTime(2019, 8, 20),
      'isFollowing': true,
      'productImages': [
        'assets/products/product4.jpg',
        'assets/products/product5.jpg',
        'assets/products/product6.jpg',
      ],
    },
    {
      'id': 'seller3',
      'name': 'Home Essentials',
      'avatar': 'H',
      'isVerified': false,
      'rating': 4.4,
      'totalReviews': 456,
      'totalProducts': 156,
      'followers': 3400,
      'responseRate': 88,
      'shipOnTime': 90,
      'joinedDate': DateTime(2021, 1, 10),
      'isFollowing': false,
      'productImages': [
        'assets/products/product1.jpg',
        'assets/products/product3.jpg',
        'assets/products/product5.jpg',
      ],
    },
  ];

  static List<Map<String, dynamic>> getAllSellers() => _sellers;

  static Map<String, dynamic>? getSellerById(String sellerId) {
    return _sellers.firstWhere((s) => s['id'] == sellerId, orElse: () => {});
  }

  static List<Map<String, dynamic>> getTopSellers() {
    var sorted = List<Map<String, dynamic>>.from(_sellers);
    sorted.sort(
      (a, b) => (b['rating'] as double).compareTo(a['rating'] as double),
    );
    return sorted.take(5).toList();
  }

  static void followSeller(String sellerId) {
    var seller = _sellers.firstWhere((s) => s['id'] == sellerId);
    seller['isFollowing'] = true;
    seller['followers'] = (seller['followers'] as int) + 1;
  }

  static void unfollowSeller(String sellerId) {
    var seller = _sellers.firstWhere((s) => s['id'] == sellerId);
    seller['isFollowing'] = false;
    seller['followers'] = (seller['followers'] as int) - 1;
  }

  static List<Map<String, dynamic>> getFollowedSellers() {
    return _sellers.where((s) => s['isFollowing'] == true).toList();
  }
}

// Product Questions & Answers Service
class QnAService {
  static List<Map<String, dynamic>> _questions = [
    {
      'id': 'q1',
      'productId': 'p1',
      'question': 'Is there a warranty for this product?',
      'askedBy': 'Rahim',
      'askedAt': DateTime.now().subtract(Duration(days: 5)),
      'answers': [
        {
          'id': 'a1',
          'answer': 'Yes, there is a 1-year warranty.',
          'answeredBy': 'Seller',
          'isSeller': true,
          'answeredAt': DateTime.now().subtract(Duration(days: 4)),
          'helpful': 23,
        },
      ],
      'upvotes': 15,
    },
    {
      'id': 'q2',
      'productId': 'p1',
      'question': 'How long does the battery last?',
      'askedBy': 'Karim',
      'askedAt': DateTime.now().subtract(Duration(days: 3)),
      'answers': [
        {
          'id': 'a2',
          'answer': 'It lasts 8-10 hours on a single charge.',
          'answeredBy': 'Verified Buyer',
          'isSeller': false,
          'answeredAt': DateTime.now().subtract(Duration(days: 2)),
          'helpful': 18,
        },
      ],
      'upvotes': 12,
    },
  ];

  static List<Map<String, dynamic>> getQuestions(String productId) {
    return _questions.where((q) => q['productId'] == productId).toList();
  }

  static void askQuestion(String productId, String question) {
    _questions.insert(0, {
      'id': 'q_${DateTime.now().millisecondsSinceEpoch}',
      'productId': productId,
      'question': question,
      'askedBy': 'You',
      'askedAt': DateTime.now(),
      'answers': [],
      'upvotes': 0,
    });
  }

  static void answerQuestion(String questionId, String answer) {
    var question = _questions.firstWhere((q) => q['id'] == questionId);
    (question['answers'] as List).add({
      'id': 'a_${DateTime.now().millisecondsSinceEpoch}',
      'answer': answer,
      'answeredBy': 'You',
      'isSeller': false,
      'answeredAt': DateTime.now(),
      'helpful': 0,
    });
  }

  static void upvoteQuestion(String questionId) {
    var question = _questions.firstWhere((q) => q['id'] == questionId);
    question['upvotes'] = (question['upvotes'] as int) + 1;
  }

  static void markAnswerHelpful(String questionId, String answerId) {
    var question = _questions.firstWhere((q) => q['id'] == questionId);
    var answer = (question['answers'] as List).firstWhere(
      (a) => a['id'] == answerId,
    );
    answer['helpful'] = (answer['helpful'] as int) + 1;
  }
}
