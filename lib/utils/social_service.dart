// Social Shopping Service
class SocialService {
  static final List<Map<String, dynamic>> _following = [
    {
      'id': 'user1',
      'name': 'Rahim Fashion',
      'avatar': 'assets/products/product1.jpg',
      'followers': 12500,
      'isVerified': true,
    },
    {
      'id': 'user2',
      'name': 'Tech Guru BD',
      'avatar': 'assets/products/product2.jpg',
      'followers': 8900,
      'isVerified': true,
    },
    {
      'id': 'user3',
      'name': 'Beauty Queen',
      'avatar': 'assets/products/product3.jpg',
      'followers': 25000,
      'isVerified': false,
    },
  ];

  static final List<Map<String, dynamic>> _feed = [
    {
      'id': 'post1',
      'user': {
        'name': 'Rahim Fashion',
        'avatar': 'assets/products/product1.jpg',
        'isVerified': true,
      },
      'content':
          'New summer collection arrived! Check out these amazing deals 🔥',
      'products': [
        {
          'id': 'p1',
          'name': 'Summer Dress',
          'price': 1500.0,
          'image': 'assets/products/product1.jpg',
        },
        {
          'id': 'p2',
          'name': 'Beach Hat',
          'price': 500.0,
          'image': 'assets/products/product2.jpg',
        },
      ],
      'likes': 234,
      'comments': 45,
      'shares': 12,
      'timestamp': DateTime.now().subtract(Duration(hours: 2)),
      'isLiked': false,
    },
    {
      'id': 'post2',
      'user': {
        'name': 'Tech Guru BD',
        'avatar': 'assets/products/product2.jpg',
        'isVerified': true,
      },
      'content': 'Best budget smartphone of 2024! Full review in comments 📱',
      'products': [
        {
          'id': 'p3',
          'name': 'Budget Phone X',
          'price': 15000.0,
          'image': 'assets/products/product3.jpg',
        },
      ],
      'likes': 567,
      'comments': 89,
      'shares': 34,
      'timestamp': DateTime.now().subtract(Duration(hours: 5)),
      'isLiked': true,
    },
  ];

  static final List<Map<String, dynamic>> _sharedWishlists = [
    {
      'id': 'wishlist1',
      'owner': 'Fatima Ahmed',
      'title': 'My Birthday Wishlist 🎂',
      'items': 8,
      'isPublic': true,
      'createdAt': DateTime.now().subtract(Duration(days: 5)),
    },
    {
      'id': 'wishlist2',
      'owner': 'Hasan Rahman',
      'title': 'Gaming Setup Goals 🎮',
      'items': 12,
      'isPublic': true,
      'createdAt': DateTime.now().subtract(Duration(days: 10)),
    },
  ];

  static List<Map<String, dynamic>> getFollowing() {
    return [
      {
        'id': 'user1',
        'name': 'রহিম ফ্যাশন',
        'posts': 45,
        'followers': 12500,
        'isVerified': true,
      },
      {
        'id': 'user2',
        'name': 'টেক গুরু BD',
        'posts': 120,
        'followers': 8900,
        'isVerified': true,
      },
      {
        'id': 'user3',
        'name': 'বিউটি কুইন',
        'posts': 89,
        'followers': 25000,
        'isVerified': false,
      },
      {
        'id': 'user4',
        'name': 'স্পোর্টস জোন',
        'posts': 67,
        'followers': 15600,
        'isVerified': true,
      },
    ];
  }

  static List<Map<String, dynamic>> getFeed() {
    return [
      {
        'id': 'post1',
        'userName': 'রহিম ফ্যাশন',
        'isVerified': true,
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'caption': 'নতুন সামার কালেকশন এসে গেছে! চেক করুন এই অসাধারণ ডিল 🔥',
        'likes': 234,
        'comments': 45,
        'isLiked': false,
        'product': {'name': 'সামার ড্রেস', 'price': 1500.0},
      },
      {
        'id': 'post2',
        'userName': 'টেক গুরু BD',
        'isVerified': true,
        'time': DateTime.now().subtract(const Duration(hours: 5)),
        'caption': '2024 এর সেরা বাজেট স্মার্টফোন! পুরো রিভিউ কমেন্টে 📱',
        'likes': 567,
        'comments': 89,
        'isLiked': true,
        'product': {'name': 'বাজেট ফোন X', 'price': 15000.0},
      },
      {
        'id': 'post3',
        'userName': 'বিউটি কুইন',
        'isVerified': false,
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'caption': 'আজকের মেকআপ লুক 💄✨',
        'likes': 892,
        'comments': 123,
        'isLiked': false,
        'product': null,
      },
    ];
  }

  static List<Map<String, dynamic>> getMyPosts() {
    return [];
  }

  static List<Map<String, dynamic>> getSharedWishlists() => _sharedWishlists;

  static void likePost(String postId) {
    var post = _feed.firstWhere((p) => p['id'] == postId);
    post['isLiked'] = !(post['isLiked'] as bool);
    post['likes'] = (post['likes'] as int) + (post['isLiked'] == true ? 1 : -1);
  }

  static void followUser(Map<String, dynamic> user) {
    if (!_following.any((f) => f['id'] == user['id'])) {
      _following.add(user);
    }
  }

  static void unfollowUser(String userId) {
    _following.removeWhere((f) => f['id'] == userId);
  }

  static Map<String, dynamic> shareWishlist(
    String title,
    List<Map<String, dynamic>> items,
  ) {
    Map<String, dynamic> wishlist = {
      'id': 'wishlist_${DateTime.now().millisecondsSinceEpoch}',
      'owner': 'You',
      'title': title,
      'items': items.length,
      'isPublic': true,
      'createdAt': DateTime.now(),
    };
    _sharedWishlists.insert(0, wishlist);
    return wishlist;
  }
}

// Live Shopping / Live Stream Service
class LiveShoppingService {
  static final List<Map<String, dynamic>> _liveStreams = [
    {
      'id': 'live1',
      'title': 'Flash Sale - 50% OFF Everything! 🔥',
      'host': 'Jihad Store Official',
      'hostAvatar': 'J',
      'viewers': 1234,
      'products': 15,
      'isLive': true,
      'thumbnail': 'assets/products/product1.jpg',
      'startedAt': DateTime.now().subtract(Duration(minutes: 45)),
    },
    {
      'id': 'live2',
      'title': 'Makeup Tutorial + Product Demo 💄',
      'host': 'Beauty Expert BD',
      'hostAvatar': 'B',
      'viewers': 892,
      'products': 8,
      'isLive': true,
      'thumbnail': 'assets/products/product2.jpg',
      'startedAt': DateTime.now().subtract(Duration(minutes: 20)),
    },
  ];

  static final List<Map<String, dynamic>> _upcomingLives = [
    {
      'id': 'upcoming1',
      'title': 'New Arrivals Showcase 🆕',
      'host': 'Jihad Store Official',
      'scheduledAt': DateTime.now().add(Duration(hours: 3)),
      'reminder': false,
    },
    {
      'id': 'upcoming2',
      'title': 'Tech Gadgets Unboxing 📦',
      'host': 'Tech Zone BD',
      'scheduledAt': DateTime.now().add(Duration(days: 1)),
      'reminder': true,
    },
  ];

  static List<Map<String, dynamic>> getLiveStreams() => _liveStreams;
  static List<Map<String, dynamic>> getUpcomingLives() => _upcomingLives;

  static void setReminder(String liveId) {
    var live = _upcomingLives.firstWhere((l) => l['id'] == liveId);
    live['reminder'] = true;
  }

  static void removeReminder(String liveId) {
    var live = _upcomingLives.firstWhere((l) => l['id'] == liveId);
    live['reminder'] = false;
  }

  static Map<String, dynamic>? getCurrentLive() {
    return _liveStreams.isNotEmpty ? _liveStreams.first : null;
  }
}
