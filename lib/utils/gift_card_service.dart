class GiftCardService {
  static List<Map<String, dynamic>> _myGiftCards = [];
  static List<Map<String, dynamic>> _purchasedGiftCards = [];

  // Available gift card denominations
  static List<int> denominations = [500, 1000, 2000, 5000, 10000];

  // Gift card designs
  static List<Map<String, dynamic>> designs = [
    {
      "name": "Birthday",
      "icon": "🎂",
      "color": 0xFFE91E63,
      "image": "assets/products/product1.jpg",
    },
    {
      "name": "Anniversary",
      "icon": "💕",
      "color": 0xFFE91E63,
      "image": "assets/products/product2.jpg",
    },
    {
      "name": "Thank You",
      "icon": "🙏",
      "color": 0xFF4CAF50,
      "image": "assets/products/product3.jpg",
    },
    {
      "name": "Congratulations",
      "icon": "🎉",
      "color": 0xFFFF9800,
      "image": "assets/products/product4.jpg",
    },
    {
      "name": "Eid Mubarak",
      "icon": "🌙",
      "color": 0xFF2196F3,
      "image": "assets/products/product5.jpg",
    },
    {
      "name": "General",
      "icon": "🎁",
      "color": 0xFF9C27B0,
      "image": "assets/products/product6.jpg",
    },
  ];

  static String _generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String code = '';
    for (int i = 0; i < 16; i++) {
      if (i > 0 && i % 4 == 0) code += '-';
      code += chars[(DateTime.now().microsecondsSinceEpoch + i) % chars.length];
    }
    return code;
  }

  static Map<String, dynamic> purchaseGiftCard({
    required int amount,
    required String recipientName,
    required String recipientEmail,
    required String message,
    required int designIndex,
  }) {
    String code = _generateCode();

    Map<String, dynamic> giftCard = {
      "code": code,
      "amount": amount,
      "balance": amount,
      "recipientName": recipientName,
      "recipientEmail": recipientEmail,
      "message": message,
      "design": designs[designIndex],
      "purchasedAt": DateTime.now(),
      "expiresAt": DateTime.now().add(Duration(days: 365)),
      "isUsed": false,
      "usedAmount": 0,
    };

    _purchasedGiftCards.add(giftCard);
    return giftCard;
  }

  static bool redeemGiftCard(String code) {
    // Check if already redeemed by user
    bool alreadyRedeemed = _myGiftCards.any((card) => card["code"] == code);
    if (alreadyRedeemed) {
      return false;
    }

    // Find gift card in purchased cards (simulating server validation)
    Map<String, dynamic>? giftCard = _purchasedGiftCards.firstWhere(
      (card) => card["code"] == code && !card["isUsed"],
      orElse: () => {},
    );

    if (giftCard.isNotEmpty) {
      _myGiftCards.add(Map.from(giftCard));
      return true;
    }

    // Demo: Accept any valid-looking code
    if (code.length == 19 && code.contains('-')) {
      _myGiftCards.add({
        "code": code,
        "amount": 1000,
        "balance": 1000,
        "recipientName": "You",
        "recipientEmail": "",
        "message": "Enjoy your shopping!",
        "design": designs[5],
        "purchasedAt": DateTime.now(),
        "expiresAt": DateTime.now().add(Duration(days: 365)),
        "isUsed": false,
        "usedAmount": 0,
      });
      return true;
    }

    return false;
  }

  static List<Map<String, dynamic>> getMyGiftCards() {
    return _myGiftCards.where((card) => card["balance"] > 0).toList();
  }

  static List<Map<String, dynamic>> getPurchasedGiftCards() {
    return _purchasedGiftCards;
  }

  static double getTotalGiftCardBalance() {
    return _myGiftCards.fold(
      0.0,
      (sum, card) => sum + (card["balance"] as int).toDouble(),
    );
  }

  static bool useGiftCardBalance(String code, double amount) {
    int index = _myGiftCards.indexWhere((card) => card["code"] == code);
    if (index != -1) {
      int balance = _myGiftCards[index]["balance"];
      if (balance >= amount) {
        _myGiftCards[index]["balance"] = balance - amount.toInt();
        _myGiftCards[index]["usedAmount"] += amount.toInt();
        if (_myGiftCards[index]["balance"] == 0) {
          _myGiftCards[index]["isUsed"] = true;
        }
        return true;
      }
    }
    return false;
  }

  static Map<String, dynamic>? getGiftCardByCode(String code) {
    try {
      return _myGiftCards.firstWhere((card) => card["code"] == code);
    } catch (e) {
      return null;
    }
  }

  // Add demo gift card for testing
  static void addDemoGiftCard() {
    if (_myGiftCards.isEmpty) {
      _myGiftCards.add({
        "code": "DEMO-CARD-1234-5678",
        "amount": 2000,
        "balance": 2000,
        "recipientName": "Demo User",
        "recipientEmail": "demo@example.com",
        "message": "Welcome to our store! 🎉",
        "design": designs[5],
        "purchasedAt": DateTime.now().subtract(Duration(days: 30)),
        "expiresAt": DateTime.now().add(Duration(days: 335)),
        "isUsed": false,
        "usedAmount": 0,
      });
    }
  }
}
