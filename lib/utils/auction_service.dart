// Auction Service - Bid on products
class AuctionService {
  static final List<Map<String, dynamic>> _activeAuctions = [
    {
      'id': 'auction1',
      'name': 'iPhone 15 Pro Max',
      'image': 'assets/products/product1.jpg',
      'startPrice': 50000.0,
      'currentBid': 85000.0,
      'minIncrement': 1000.0,
      'totalBids': 45,
      'endTime': DateTime.now().add(const Duration(hours: 5)),
      'topBidder': 'user123',
      'description': 'Brand new sealed iPhone 15 Pro Max 256GB',
    },
    {
      'id': 'auction2',
      'name': 'Samsung Galaxy Watch 6',
      'image': 'assets/products/product2.jpg',
      'startPrice': 15000.0,
      'currentBid': 22500.0,
      'minIncrement': 500.0,
      'totalBids': 28,
      'endTime': DateTime.now().add(const Duration(hours: 12)),
      'topBidder': 'user456',
      'description': 'Galaxy Watch 6 Classic 47mm',
    },
    {
      'id': 'auction3',
      'name': 'MacBook Pro M3',
      'image': 'assets/products/product3.jpg',
      'startPrice': 150000.0,
      'currentBid': 185000.0,
      'minIncrement': 5000.0,
      'totalBids': 18,
      'endTime': DateTime.now().add(const Duration(days: 2)),
      'topBidder': 'user789',
      'description': 'MacBook Pro 14" M3 Pro 18GB RAM 512GB SSD',
    },
  ];

  static final List<Map<String, dynamic>> _upcomingAuctions = [
    {
      'id': 'upcoming1',
      'name': 'Sony PlayStation 5',
      'currentBid': 45000.0,
      'totalBids': 0,
      'endTime': DateTime.now().add(const Duration(days: 1)),
      'image': 'assets/products/product4.jpg',
    },
    {
      'id': 'upcoming2',
      'name': 'DJI Mavic 3 Drone',
      'currentBid': 120000.0,
      'totalBids': 0,
      'endTime': DateTime.now().add(const Duration(days: 2)),
      'image': 'assets/products/product5.jpg',
    },
  ];

  static final List<Map<String, dynamic>> _myBids = [];

  static final Map<String, List<Map<String, dynamic>>> _bidHistory = {
    'auction1': [
      {
        'bidder': 'রহিম',
        'amount': 85000.0,
        'time': DateTime.now().subtract(const Duration(minutes: 5)),
      },
      {
        'bidder': 'করিম',
        'amount': 84000.0,
        'time': DateTime.now().subtract(const Duration(minutes: 15)),
      },
      {
        'bidder': 'জামাল',
        'amount': 82000.0,
        'time': DateTime.now().subtract(const Duration(minutes: 30)),
      },
      {
        'bidder': 'রহিম',
        'amount': 80000.0,
        'time': DateTime.now().subtract(const Duration(hours: 1)),
      },
      {
        'bidder': 'সালাম',
        'amount': 75000.0,
        'time': DateTime.now().subtract(const Duration(hours: 2)),
      },
    ],
    'auction2': [
      {
        'bidder': 'আমিন',
        'amount': 22500.0,
        'time': DateTime.now().subtract(const Duration(minutes: 10)),
      },
      {
        'bidder': 'বাবুল',
        'amount': 21000.0,
        'time': DateTime.now().subtract(const Duration(minutes: 25)),
      },
    ],
  };

  static List<Map<String, dynamic>> getLiveAuctions() => _activeAuctions;

  static List<Map<String, dynamic>> getUpcomingAuctions() => _upcomingAuctions;

  static List<Map<String, dynamic>> getActiveAuctions() => _activeAuctions;

  static List<Map<String, dynamic>> getMyBids() => _myBids;

  static List<Map<String, dynamic>> getBidHistory(String auctionId) {
    return _bidHistory[auctionId] ?? [];
  }

  static bool placeBid(String auctionId, double amount) {
    final auctionIndex = _activeAuctions.indexWhere(
      (a) => a['id'] == auctionId,
    );
    if (auctionIndex == -1) return false;

    final auction = _activeAuctions[auctionIndex];
    final currentBid = auction['currentBid'] as double;
    final minIncrement = auction['minIncrement'] as double? ?? 100.0;

    if (amount >= currentBid + minIncrement) {
      _activeAuctions[auctionIndex]['currentBid'] = amount;
      _activeAuctions[auctionIndex]['topBidder'] = 'আপনি';
      _activeAuctions[auctionIndex]['totalBids'] =
          (auction['totalBids'] as int) + 1;

      // Add to my bids
      final existingBidIndex = _myBids.indexWhere(
        (b) => b['auctionId'] == auctionId,
      );
      if (existingBidIndex >= 0) {
        _myBids[existingBidIndex]['amount'] = amount;
        _myBids[existingBidIndex]['isWinning'] = true;
      } else {
        _myBids.add({
          'auctionId': auctionId,
          'productName': auction['name'],
          'amount': amount,
          'time': DateTime.now(),
          'isWinning': true,
        });
      }

      // Update other bids to not winning
      for (var bid in _myBids) {
        if (bid['auctionId'] != auctionId) {
          final otherAuction = _activeAuctions.firstWhere(
            (a) => a['id'] == bid['auctionId'],
            orElse: () => {},
          );
          if (otherAuction.isNotEmpty) {
            bid['isWinning'] = otherAuction['topBidder'] == 'আপনি';
          }
        }
      }

      return true;
    }
    return false;
  }

  static Duration getRemainingTime(String auctionId) {
    final auction = _activeAuctions.firstWhere(
      (a) => a['id'] == auctionId,
      orElse: () => {'endTime': DateTime.now()},
    );
    return (auction['endTime'] as DateTime).difference(DateTime.now());
  }
}
