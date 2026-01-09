// Lucky Draw / Lottery Service
class LotteryService {
  static int _userTickets = 5;
  static int _totalTickets = 10000;
  static List<Map<String, dynamic>> _prizes = [
    {
      'position': '1st',
      'prize': 'iPhone 15 Pro Max',
      'value': 180000.0,
      'image': 'assets/products/product1.jpg',
      'winner': null,
    },
    {
      'position': '2nd',
      'prize': 'Samsung Galaxy S24 Ultra',
      'value': 150000.0,
      'image': 'assets/products/product2.jpg',
      'winner': null,
    },
    {
      'position': '3rd',
      'prize': 'Apple Watch Ultra 2',
      'value': 95000.0,
      'image': 'assets/products/product3.jpg',
      'winner': null,
    },
    {
      'position': '4th-10th',
      'prize': '৳10,000 Gift Card',
      'value': 10000.0,
      'image': 'assets/logo/logo1.png',
      'winner': null,
    },
    {
      'position': '11th-50th',
      'prize': '৳1,000 Coupon',
      'value': 1000.0,
      'image': 'assets/logo/logo1.png',
      'winner': null,
    },
  ];

  static List<Map<String, dynamic>> _myTickets = [
    {
      'ticketNumber': 'LK-2024-00892',
      'purchaseDate': DateTime.now().subtract(Duration(days: 5)),
    },
    {
      'ticketNumber': 'LK-2024-01234',
      'purchaseDate': DateTime.now().subtract(Duration(days: 3)),
    },
    {
      'ticketNumber': 'LK-2024-02456',
      'purchaseDate': DateTime.now().subtract(Duration(days: 2)),
    },
    {
      'ticketNumber': 'LK-2024-03789',
      'purchaseDate': DateTime.now().subtract(Duration(days: 1)),
    },
    {'ticketNumber': 'LK-2024-04123', 'purchaseDate': DateTime.now()},
  ];

  static DateTime _drawDate = DateTime.now().add(Duration(days: 7));

  static int getUserTickets() => _userTickets;
  static int getTotalTickets() => _totalTickets;
  static List<Map<String, dynamic>> getPrizes() => _prizes;
  static List<Map<String, dynamic>> getMyTickets() => _myTickets;
  static DateTime getDrawDate() => _drawDate;

  static bool buyTicket({int count = 1, double pricePerTicket = 100.0}) {
    _userTickets += count;
    String ticketNumber =
        'LK-2024-${(_myTickets.length * 1111 + 5000).toString().padLeft(5, '0')}';
    _myTickets.add({
      'ticketNumber': ticketNumber,
      'purchaseDate': DateTime.now(),
    });
    return true;
  }

  static double getWinningChance() {
    return (_userTickets / _totalTickets) * 100;
  }

  static Map<String, dynamic>? checkWinner(String ticketNumber) {
    // Simulate winner check
    return null;
  }
}

// Spin Wheel Service
class SpinWheelService {
  static int _spinsRemaining = 3;
  static DateTime? _lastSpinDate;

  static List<Map<String, dynamic>> _rewards = [
    {'label': '৳50 OFF', 'type': 'coupon', 'value': 50, 'probability': 0.25},
    {'label': '৳100 OFF', 'type': 'coupon', 'value': 100, 'probability': 0.15},
    {'label': '৳200 OFF', 'type': 'coupon', 'value': 200, 'probability': 0.10},
    {'label': '৳500 OFF', 'type': 'coupon', 'value': 500, 'probability': 0.05},
    {
      'label': 'Free Shipping',
      'type': 'shipping',
      'value': 0,
      'probability': 0.20,
    },
    {'label': '5 Coins', 'type': 'coins', 'value': 5, 'probability': 0.10},
    {'label': '10 Coins', 'type': 'coins', 'value': 10, 'probability': 0.08},
    {'label': 'Better Luck', 'type': 'none', 'value': 0, 'probability': 0.07},
  ];

  static List<Map<String, dynamic>> _wonRewards = [
    {
      'reward': '৳50 OFF',
      'wonAt': DateTime.now().subtract(Duration(days: 2)),
      'used': true,
    },
    {
      'reward': 'Free Shipping',
      'wonAt': DateTime.now().subtract(Duration(days: 1)),
      'used': false,
    },
  ];

  static int getSpinsRemaining() => _spinsRemaining;
  static List<Map<String, dynamic>> getRewards() => _rewards;
  static List<Map<String, dynamic>> getWonRewards() => _wonRewards;

  static Map<String, dynamic> spin() {
    if (_spinsRemaining <= 0) {
      return {'success': false, 'message': 'কোন স্পিন বাকি নেই'};
    }

    _spinsRemaining--;
    _lastSpinDate = DateTime.now();

    // Random reward selection based on probability
    double random = DateTime.now().millisecond / 1000;
    double cumulative = 0;
    Map<String, dynamic> selectedReward = _rewards.last;

    for (var reward in _rewards) {
      cumulative += reward['probability'] as double;
      if (random <= cumulative) {
        selectedReward = reward;
        break;
      }
    }

    if (selectedReward['type'] != 'none') {
      _wonRewards.add({
        'reward': selectedReward['label'],
        'wonAt': DateTime.now(),
        'used': false,
      });
    }

    return {'success': true, 'reward': selectedReward};
  }

  static void resetDailySpins() {
    if (_lastSpinDate != null) {
      if (DateTime.now().difference(_lastSpinDate!).inHours >= 24) {
        _spinsRemaining = 3;
      }
    }
  }
}
