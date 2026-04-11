// Gamification / Rewards Service
class GamificationService {
  static int _userLevel = 5;
  static int _currentXP = 2500;
  static int _xpToNextLevel = 3000;
  static int _coins = 1250;
  static int _streak = 7;

  static final List<Map<String, dynamic>> _levels = [
    {
      'level': 1,
      'name': 'নবাগত',
      'xpRequired': 0,
      'badge': '🌱',
      'image': 'assets/products/product1.jpg',
    },
    {
      'level': 2,
      'name': 'এক্সপ্লোরার',
      'xpRequired': 500,
      'badge': '🔍',
      'image': 'assets/products/product2.jpg',
    },
    {
      'level': 3,
      'name': 'শপার',
      'xpRequired': 1000,
      'badge': '🛒',
      'image': 'assets/products/product3.jpg',
    },
    {
      'level': 4,
      'name': 'স্মার্ট শপার',
      'xpRequired': 2000,
      'badge': '⭐',
      'image': 'assets/products/product4.jpg',
    },
    {
      'level': 5,
      'name': 'প্রো শপার',
      'xpRequired': 3000,
      'badge': '💎',
      'image': 'assets/products/product5.jpg',
    },
    {
      'level': 6,
      'name': 'এলিট',
      'xpRequired': 5000,
      'badge': '👑',
      'image': 'assets/products/product6.jpg',
    },
    {
      'level': 7,
      'name': 'লিজেন্ড',
      'xpRequired': 10000,
      'badge': '🏆',
      'image': 'assets/products/product7.jpg',
    },
    {
      'level': 8,
      'name': 'মাস্টার',
      'xpRequired': 20000,
      'badge': '🌟',
      'image': 'assets/products/product8.jpg',
    },
    {
      'level': 9,
      'name': 'গ্র্যান্ডমাস্টার',
      'xpRequired': 50000,
      'badge': '⚡',
      'image': 'assets/products/product1.jpg',
    },
    {
      'level': 10,
      'name': 'আলটিমেট',
      'xpRequired': 100000,
      'badge': '🔥',
      'image': 'assets/products/product2.jpg',
    },
  ];

  static final List<Map<String, dynamic>> _achievements = [
    {
      'id': 'ach1',
      'name': 'প্রথম অর্ডার',
      'description': 'আপনার প্রথম অর্ডার সম্পন্ন করুন',
      'icon': '🎉',
      'xpReward': 100,
      'coinReward': 50,
      'unlocked': true,
      'unlockedAt': DateTime.now().subtract(Duration(days: 30)),
      'image': 'assets/products/product3.jpg',
    },
    {
      'id': 'ach2',
      'name': 'রিভিউ মাস্টার',
      'description': '১০টি প্রোডাক্ট রিভিউ দিন',
      'icon': '✍️',
      'xpReward': 200,
      'coinReward': 100,
      'unlocked': true,
      'progress': 10,
      'target': 10,
      'image': 'assets/products/product4.jpg',
    },
    {
      'id': 'ach3',
      'name': 'স্ট্রিক চ্যাম্পিয়ন',
      'description': 'টানা ৭ দিন অ্যাপ ব্যবহার করুন',
      'icon': '🔥',
      'xpReward': 300,
      'coinReward': 150,
      'unlocked': true,
      'progress': 7,
      'target': 7,
      'image': 'assets/products/product5.jpg',
    },
    {
      'id': 'ach4',
      'name': 'বিগ স্পেন্ডার',
      'description': '৳১০,০০০+ খরচ করুন',
      'icon': '💰',
      'xpReward': 500,
      'coinReward': 250,
      'unlocked': false,
      'progress': 7500,
      'target': 10000,
      'image': 'assets/products/product6.jpg',
    },
    {
      'id': 'ach5',
      'name': 'সোশ্যাল বাটারফ্লাই',
      'description': '৫ জন বন্ধুকে রেফার করুন',
      'icon': '👥',
      'xpReward': 400,
      'coinReward': 200,
      'unlocked': false,
      'progress': 2,
      'target': 5,
      'image': 'assets/products/product7.jpg',
    },
  ];

  static final List<Map<String, dynamic>> _dailyChallenges = [
    {
      'id': 'dc1',
      'name': 'ডেইলি চেক-ইন',
      'description': 'আজ অ্যাপ ওপেন করুন',
      'xpReward': 10,
      'coinReward': 5,
      'completed': true,
    },
    {
      'id': 'dc2',
      'name': 'প্রোডাক্ট ব্রাউজ',
      'description': '১০টি প্রোডাক্ট দেখুন',
      'xpReward': 20,
      'coinReward': 10,
      'completed': false,
      'progress': 6,
      'target': 10,
    },
    {
      'id': 'dc3',
      'name': 'কার্টে যোগ করুন',
      'description': '৩টি আইটেম কার্টে যোগ করুন',
      'xpReward': 30,
      'coinReward': 15,
      'completed': false,
      'progress': 1,
      'target': 3,
    },
    {
      'id': 'dc4',
      'name': 'রিভিউ লিখুন',
      'description': '১টি প্রোডাক্ট রিভিউ দিন',
      'xpReward': 50,
      'coinReward': 25,
      'completed': false,
      'progress': 0,
      'target': 1,
    },
  ];

  static int getLevel() => _userLevel;
  static int getCurrentXP() => _currentXP;
  static int getXPToNextLevel() => _xpToNextLevel;
  static int getCoins() => _coins;
  static int getStreak() => _streak;
  static List<Map<String, dynamic>> getLevels() => _levels;
  static List<Map<String, dynamic>> getAchievements() => _achievements;
  static List<Map<String, dynamic>> getDailyChallenges() => _dailyChallenges;

  static Map<String, dynamic> getCurrentLevelInfo() {
    return _levels.firstWhere((l) => l['level'] == _userLevel);
  }

  static double getProgressToNextLevel() {
    int currentLevelXP =
        _levels.firstWhere((l) => l['level'] == _userLevel)['xpRequired']
            as int;
    int nextLevelXP =
        _levels.firstWhere(
              (l) => l['level'] == _userLevel + 1,
              orElse: () => {'xpRequired': _xpToNextLevel},
            )['xpRequired']
            as int;
    return (_currentXP - currentLevelXP) / (nextLevelXP - currentLevelXP);
  }

  static void addXP(int amount) {
    _currentXP += amount;
    if (_currentXP >= _xpToNextLevel && _userLevel < 10) {
      _userLevel++;
      _xpToNextLevel =
          _levels.firstWhere(
                (l) => l['level'] == _userLevel + 1,
                orElse: () => {'xpRequired': _xpToNextLevel * 2},
              )['xpRequired']
              as int;
    }
  }

  static void addCoins(int amount) {
    _coins += amount;
  }

  static bool spendCoins(int amount) {
    if (_coins >= amount) {
      _coins -= amount;
      return true;
    }
    return false;
  }

  static void incrementStreak() {
    _streak++;
  }

  static void resetStreak() {
    _streak = 0;
  }

  static List<Map<String, dynamic>> getUnlockedAchievements() {
    return _achievements.where((a) => a['unlocked'] == true).toList();
  }

  static List<Map<String, dynamic>> getInProgressAchievements() {
    return _achievements.where((a) => a['unlocked'] == false).toList();
  }

  static int getCompletedChallengesCount() {
    return _dailyChallenges.where((c) => c['completed'] == true).length;
  }
}

// Leaderboard Service
class LeaderboardService {
  static final List<Map<String, dynamic>> _weeklyLeaderboard = [
    {'rank': 1, 'name': 'Rahim M.', 'avatar': 'R', 'xp': 5200, 'badge': '🥇'},
    {'rank': 2, 'name': 'Fatima K.', 'avatar': 'F', 'xp': 4800, 'badge': '🥈'},
    {'rank': 3, 'name': 'Karim A.', 'avatar': 'K', 'xp': 4500, 'badge': '🥉'},
    {'rank': 4, 'name': 'Sara B.', 'avatar': 'S', 'xp': 4200, 'badge': ''},
    {'rank': 5, 'name': 'Hasan R.', 'avatar': 'H', 'xp': 3900, 'badge': ''},
    {
      'rank': 6,
      'name': 'You',
      'avatar': 'Y',
      'xp': 2500,
      'badge': '',
      'isCurrentUser': true,
    },
  ];

  static final List<Map<String, dynamic>> _monthlyLeaderboard = [
    {
      'rank': 1,
      'name': 'Tech Master',
      'avatar': 'T',
      'xp': 25000,
      'badge': '🏆',
    },
    {
      'rank': 2,
      'name': 'Shopping Queen',
      'avatar': 'S',
      'xp': 22000,
      'badge': '🥈',
    },
    {
      'rank': 3,
      'name': 'Deal Hunter',
      'avatar': 'D',
      'xp': 20000,
      'badge': '🥉',
    },
  ];

  static List<Map<String, dynamic>> getWeeklyLeaderboard() =>
      _weeklyLeaderboard;
  static List<Map<String, dynamic>> getMonthlyLeaderboard() =>
      _monthlyLeaderboard;

  static int getCurrentUserRank() {
    var user = _weeklyLeaderboard.firstWhere(
      (l) => l['isCurrentUser'] == true,
      orElse: () => {},
    );
    return user.isNotEmpty ? user['rank'] as int : 0;
  }
}
