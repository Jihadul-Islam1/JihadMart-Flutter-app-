// Affiliate / Referral Program Service
class AffiliateService {
  static String _referralCode = 'JIHAD2024';
  static double _totalEarnings = 2500.0;
  static double _pendingEarnings = 750.0;
  static double _withdrawableBalance = 1750.0;
  static int _totalReferrals = 12;
  static int _activeReferrals = 8;

  static List<Map<String, dynamic>> _referralHistory = [
    {
      'name': 'Rahim Mia',
      'email': 'rahim@email.com',
      'joinedDate': DateTime.now().subtract(Duration(days: 30)),
      'status': 'active',
      'totalOrders': 5,
      'commission': 500.0,
      'avatar': 'assets/products/product1.jpg',
    },
    {
      'name': 'Karim Uddin',
      'email': 'karim@email.com',
      'joinedDate': DateTime.now().subtract(Duration(days: 25)),
      'status': 'active',
      'totalOrders': 3,
      'commission': 350.0,
      'avatar': 'assets/products/product2.jpg',
    },
    {
      'name': 'Fatima Begum',
      'email': 'fatima@email.com',
      'joinedDate': DateTime.now().subtract(Duration(days: 20)),
      'status': 'active',
      'totalOrders': 8,
      'commission': 800.0,
      'avatar': 'assets/products/product3.jpg',
    },
    {
      'name': 'Hasan Ahmed',
      'email': 'hasan@email.com',
      'joinedDate': DateTime.now().subtract(Duration(days: 15)),
      'status': 'pending',
      'totalOrders': 1,
      'commission': 100.0,
      'avatar': 'assets/products/product4.jpg',
    },
  ];

  static List<Map<String, dynamic>> _commissionRates = [
    {'category': 'Electronics', 'rate': 5.0},
    {'category': 'Fashion', 'rate': 10.0},
    {'category': 'Beauty', 'rate': 12.0},
    {'category': 'Home & Living', 'rate': 8.0},
    {'category': 'Books', 'rate': 4.0},
    {'category': 'Others', 'rate': 6.0},
  ];

  static List<Map<String, dynamic>> _withdrawHistory = [
    {
      'amount': 1000.0,
      'method': 'bKash',
      'account': '01712345678',
      'date': DateTime.now().subtract(Duration(days: 15)),
      'status': 'completed',
    },
    {
      'amount': 500.0,
      'method': 'Nagad',
      'account': '01812345678',
      'date': DateTime.now().subtract(Duration(days: 30)),
      'status': 'completed',
    },
  ];

  static String getReferralCode() => _referralCode;
  static double getTotalEarnings() => _totalEarnings;
  static double getPendingEarnings() => _pendingEarnings;
  static double getWithdrawableBalance() => _withdrawableBalance;
  static int getTotalReferrals() => _totalReferrals;
  static int getActiveReferrals() => _activeReferrals;
  static List<Map<String, dynamic>> getReferralHistory() => _referralHistory;
  static List<Map<String, dynamic>> getCommissionRates() => _commissionRates;
  static List<Map<String, dynamic>> getWithdrawHistory() => _withdrawHistory;

  static String generateReferralLink() {
    return 'https://jihadshop.com/ref/$_referralCode';
  }

  static bool withdraw(double amount, String method, String account) {
    if (amount <= _withdrawableBalance && amount >= 500) {
      _withdrawableBalance -= amount;
      _withdrawHistory.insert(0, {
        'amount': amount,
        'method': method,
        'account': account,
        'date': DateTime.now(),
        'status': 'processing',
      });
      return true;
    }
    return false;
  }

  static Map<String, dynamic> getStats() {
    return {
      'totalEarnings': _totalEarnings,
      'pendingEarnings': _pendingEarnings,
      'withdrawableBalance': _withdrawableBalance,
      'totalReferrals': _totalReferrals,
      'activeReferrals': _activeReferrals,
      'conversionRate': (_activeReferrals / _totalReferrals * 100)
          .toStringAsFixed(1),
    };
  }
}

// Influencer Program Service
class InfluencerService {
  static String _tier = 'Silver'; // Bronze, Silver, Gold, Platinum, Diamond
  static int _followers = 5000;
  static double _monthlyCommission = 15000.0;

  static List<Map<String, dynamic>> _tiers = [
    {
      'tier': 'Bronze',
      'minFollowers': 1000,
      'commission': 8.0,
      'perks': ['Exclusive Products', 'Early Access'],
    },
    {
      'tier': 'Silver',
      'minFollowers': 5000,
      'commission': 10.0,
      'perks': ['Free Samples', 'Priority Support', 'Exclusive Products'],
    },
    {
      'tier': 'Gold',
      'minFollowers': 25000,
      'commission': 12.0,
      'perks': ['Free Samples', 'Brand Deals', 'VIP Events'],
    },
    {
      'tier': 'Platinum',
      'minFollowers': 100000,
      'commission': 15.0,
      'perks': [
        'Sponsored Posts',
        'Product Launch Features',
        'Dedicated Manager',
      ],
    },
    {
      'tier': 'Diamond',
      'minFollowers': 500000,
      'commission': 20.0,
      'perks': ['Co-Branded Products', 'Revenue Share', 'Global Campaigns'],
    },
  ];

  static List<Map<String, dynamic>> _campaigns = [
    {
      'name': 'Summer Fashion Campaign',
      'budget': 50000.0,
      'deadline': DateTime.now().add(Duration(days: 15)),
      'requirements': 'Create 3 posts featuring summer collection',
      'status': 'active',
    },
    {
      'name': 'Tech Review Series',
      'budget': 30000.0,
      'deadline': DateTime.now().add(Duration(days: 30)),
      'requirements': 'Unboxing and review video',
      'status': 'open',
    },
  ];

  static String getTier() => _tier;
  static int getFollowers() => _followers;
  static double getMonthlyCommission() => _monthlyCommission;
  static List<Map<String, dynamic>> getTiers() => _tiers;
  static List<Map<String, dynamic>> getCampaigns() => _campaigns;

  static Map<String, dynamic> getCurrentTierInfo() {
    return _tiers.firstWhere((t) => t['tier'] == _tier);
  }

  static bool applyForCampaign(String campaignName) {
    return true;
  }
}
