// Personalization / Recommendation Service
class RecommendationService {
  static final List<Map<String, dynamic>> _forYouProducts = [
    {
      'id': 'rec1',
      'name': 'Recommended Earbuds',
      'price': 3500.0,
      'image': 'assets/products/product1.jpg',
      'rating': 4.7,
      'reason': 'Based on your browsing history',
    },
    {
      'id': 'rec2',
      'name': 'Smart Watch for You',
      'price': 5500.0,
      'image': 'assets/products/product2.jpg',
      'rating': 4.8,
      'reason': 'Similar to items you viewed',
    },
    {
      'id': 'rec3',
      'name': 'Perfect Gift Idea',
      'price': 2500.0,
      'image': 'assets/products/product3.jpg',
      'rating': 4.5,
      'reason': 'Trending in your area',
    },
  ];

  static final List<Map<String, dynamic>> _frequentlyBoughtTogether = [
    {
      'products': [
        {
          'name': 'Phone Case',
          'price': 500.0,
          'image': 'assets/products/product1.jpg',
        },
        {
          'name': 'Screen Protector',
          'price': 300.0,
          'image': 'assets/products/product2.jpg',
        },
        {
          'name': 'Charger',
          'price': 800.0,
          'image': 'assets/products/product3.jpg',
        },
      ],
      'bundlePrice': 1400.0,
      'originalPrice': 1600.0,
      'savings': 200.0,
    },
  ];

  static final List<Map<String, dynamic>> _trendingProducts = [
    {
      'id': 'trend1',
      'name': 'Viral Product',
      'price': 1999.0,
      'image': 'assets/products/product1.jpg',
      'sold': 5000,
      'growth': '+250%',
    },
  ];

  static List<Map<String, dynamic>> getForYouProducts() => _forYouProducts;
  static List<Map<String, dynamic>> getFrequentlyBoughtTogether() =>
      _frequentlyBoughtTogether;
  static List<Map<String, dynamic>> getTrendingProducts() => _trendingProducts;

  static List<Map<String, dynamic>> getSimilarProducts(String productId) {
    return [
      {
        'id': 'sim1',
        'name': 'Similar 1',
        'price': 2500.0,
        'image': 'assets/products/product1.jpg',
      },
      {
        'id': 'sim2',
        'name': 'Similar 2',
        'price': 2800.0,
        'image': 'assets/products/product2.jpg',
      },
      {
        'id': 'sim3',
        'name': 'Similar 3',
        'price': 2300.0,
        'image': 'assets/products/product3.jpg',
      },
    ];
  }

  static List<Map<String, dynamic>> getAlsoBought(String productId) {
    return [
      {
        'id': 'also1',
        'name': 'Also Bought 1',
        'price': 500.0,
        'image': 'assets/products/product1.jpg',
      },
      {
        'id': 'also2',
        'name': 'Also Bought 2',
        'price': 800.0,
        'image': 'assets/products/product2.jpg',
      },
    ];
  }
}

// Search History & Suggestions Service
class SearchHistoryService {
  static List<String> _searchHistory = [
    'ওয়্যারলেস ইয়ারবাড',
    'স্মার্ট ওয়াচ',
    'লেদার ব্যাগ',
    'মোবাইল কভার',
    'পাওয়ার ব্যাংক',
  ];

  static final List<String> _popularSearches = [
    'iPhone 15',
    'Samsung Galaxy',
    'Wireless Earbuds',
    'Smart Watch',
    'Nike Shoes',
    'Adidas Bag',
    'Laptop Stand',
    'Gaming Mouse',
  ];

  static final List<String> _trendingSearches = [
    'Summer Sale 🔥',
    'Back to School 📚',
    'Eid Collection 🌙',
    'Flash Deal ⚡',
  ];

  static List<String> getSearchHistory() => _searchHistory;
  static List<String> getPopularSearches() => _popularSearches;
  static List<String> getTrendingSearches() => _trendingSearches;

  static void addToHistory(String query) {
    _searchHistory.remove(query);
    _searchHistory.insert(0, query);
    if (_searchHistory.length > 20) {
      _searchHistory = _searchHistory.take(20).toList();
    }
  }

  static void removeFromHistory(String query) {
    _searchHistory.remove(query);
  }

  static void clearHistory() {
    _searchHistory.clear();
  }

  static List<String> getSuggestions(String query) {
    if (query.isEmpty) return [];

    String lowercaseQuery = query.toLowerCase();
    List<String> suggestions = [];

    // From history
    suggestions.addAll(
      _searchHistory
          .where((s) => s.toLowerCase().contains(lowercaseQuery))
          .take(3),
    );

    // From popular
    suggestions.addAll(
      _popularSearches
          .where(
            (s) =>
                s.toLowerCase().contains(lowercaseQuery) &&
                !suggestions.contains(s),
          )
          .take(5),
    );

    return suggestions;
  }
}

// Saved Filters & Preferences
class FilterPreferencesService {
  static Map<String, dynamic> _savedFilters = {
    'priceRange': {'min': 0.0, 'max': 50000.0},
    'brands': <String>[],
    'categories': <String>[],
    'ratings': 0.0,
    'freeShipping': false,
    'inStock': true,
    'discount': false,
  };

  static final List<Map<String, dynamic>> _savedSearches = [
    {
      'id': 'saved1',
      'name': 'Budget Electronics',
      'query': 'electronics',
      'filters': {
        'priceRange': {'min': 0.0, 'max': 5000.0},
      },
      'notifyOnNew': true,
    },
    {
      'id': 'saved2',
      'name': 'Nike Shoes',
      'query': 'shoes',
      'filters': {
        'brands': ['Nike'],
      },
      'notifyOnNew': false,
    },
  ];

  static Map<String, dynamic> getSavedFilters() => _savedFilters;
  static List<Map<String, dynamic>> getSavedSearches() => _savedSearches;

  static void saveFilters(Map<String, dynamic> filters) {
    _savedFilters = filters;
  }

  static void saveSearch(
    String name,
    String query,
    Map<String, dynamic> filters, {
    bool notifyOnNew = false,
  }) {
    _savedSearches.add({
      'id': 'saved_${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'query': query,
      'filters': filters,
      'notifyOnNew': notifyOnNew,
    });
  }

  static void deleteSavedSearch(String id) {
    _savedSearches.removeWhere((s) => s['id'] == id);
  }

  static void toggleNotification(String id) {
    var search = _savedSearches.firstWhere((s) => s['id'] == id);
    search['notifyOnNew'] = !(search['notifyOnNew'] as bool);
  }
}
