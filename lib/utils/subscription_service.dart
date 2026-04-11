// Subscription Box Service - Monthly subscription boxes
class SubscriptionService {
  static final List<Map<String, dynamic>> _subscriptionPlans = [
    {
      'id': 'basic',
      'name': 'Basic Box',
      'price': 999.0,
      'frequency': 'monthly',
      'description': 'প্রতি মাসে ৩টি সারপ্রাইজ প্রোডাক্ট',
      'products': 3,
      'savings': '20%',
      'features': ['Free Shipping', 'Cancel Anytime', '3 Products'],
      'color': 0xFF4CAF50,
      'image': 'assets/products/product8.jpg',
      'icon':
          0xe14f, // Icons.card_giftcard code point? No, let's use int and map it or just use a default icon in UI
    },
    {
      'id': 'premium',
      'name': 'Premium Box',
      'price': 1999.0,
      'frequency': 'monthly',
      'description': 'প্রতি মাসে ৬টি প্রিমিয়াম প্রোডাক্ট',
      'products': 6,
      'savings': '35%',
      'features': [
        'Free Shipping',
        'Priority Support',
        '6 Products',
        'Exclusive Items',
      ],
      'color': 0xFF9C27B0,
      'image': 'assets/products/product7.jpg',
      'icon': 0xe5f8, // Icons.star
    },
    {
      'id': 'vip',
      'name': 'VIP Box',
      'price': 3999.0,
      'frequency': 'monthly',
      'description': 'প্রতি মাসে ১০টি এক্সক্লুসিভ প্রোডাক্ট',
      'products': 10,
      'savings': '50%',
      'features': [
        'Free Express Shipping',
        '24/7 VIP Support',
        '10 Products',
        'Early Access',
        'Gift Wrapping',
      ],
      'color': 0xFFFFD700,
      'image': 'assets/products/product6.jpg',
      'icon': 0xe1d7, // Icons.diamond
    },
  ];

  static Map<String, dynamic>? _activeSubscription;

  static List<Map<String, dynamic>> getPlans() => _subscriptionPlans;

  static Map<String, dynamic>? getActiveSubscription() => _activeSubscription;

  static void subscribe(String planId) {
    _activeSubscription = _subscriptionPlans.firstWhere(
      (p) => p['id'] == planId,
    );
    _activeSubscription!['startDate'] = DateTime.now();
    _activeSubscription!['nextDelivery'] = DateTime.now().add(
      Duration(days: 30),
    );
  }

  static void cancelSubscription() {
    _activeSubscription = null;
  }

  static List<Map<String, dynamic>> getDeliveryHistory() {
    return [
      {
        'date': DateTime.now().subtract(Duration(days: 60)),
        'status': 'Delivered',
        'items': 6,
        'rating': 4.5,
      },
      {
        'date': DateTime.now().subtract(Duration(days: 30)),
        'status': 'Delivered',
        'items': 6,
        'rating': 5.0,
      },
    ];
  }
}
