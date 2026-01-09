import 'package:flutter/material.dart';

class LoyaltyService {
  static int _points = 0;
  static List<Map<String, dynamic>> _pointsHistory = [];
  static String _membershipTier = "Bronze";

  // Points earned per 100 BDT spent
  static const int pointsPerHundred = 10;

  // Membership tiers
  static Map<String, Map<String, dynamic>> tiers = {
    "Bronze": {"minPoints": 0, "discount": 0, "color": Colors.brown},
    "Silver": {"minPoints": 500, "discount": 5, "color": Colors.grey},
    "Gold": {"minPoints": 1500, "discount": 10, "color": Colors.amber},
    "Platinum": {"minPoints": 5000, "discount": 15, "color": Colors.blueGrey},
    "Diamond": {"minPoints": 10000, "discount": 20, "color": Colors.blue},
  };

  static int getPoints() => _points;

  static String getMembershipTier() => _membershipTier;

  static Color getTierColor() {
    return tiers[_membershipTier]?["color"] ?? Colors.brown;
  }

  static int getTierDiscount() {
    return tiers[_membershipTier]?["discount"] ?? 0;
  }

  static int getPointsToNextTier() {
    List<String> tierOrder = [
      "Bronze",
      "Silver",
      "Gold",
      "Platinum",
      "Diamond",
    ];
    int currentIndex = tierOrder.indexOf(_membershipTier);

    if (currentIndex < tierOrder.length - 1) {
      String nextTier = tierOrder[currentIndex + 1];
      int nextTierPoints = tiers[nextTier]?["minPoints"] ?? 0;
      return nextTierPoints - _points;
    }
    return 0; // Already at highest tier
  }

  static String getNextTierName() {
    List<String> tierOrder = [
      "Bronze",
      "Silver",
      "Gold",
      "Platinum",
      "Diamond",
    ];
    int currentIndex = tierOrder.indexOf(_membershipTier);

    if (currentIndex < tierOrder.length - 1) {
      return tierOrder[currentIndex + 1];
    }
    return "Max Level";
  }

  static void _updateTier() {
    if (_points >= 10000) {
      _membershipTier = "Diamond";
    } else if (_points >= 5000) {
      _membershipTier = "Platinum";
    } else if (_points >= 1500) {
      _membershipTier = "Gold";
    } else if (_points >= 500) {
      _membershipTier = "Silver";
    } else {
      _membershipTier = "Bronze";
    }
  }

  static void addPoints(double purchaseAmount, String description) {
    int earnedPoints = (purchaseAmount / 100 * pointsPerHundred).round();
    _points += earnedPoints;

    _pointsHistory.add({
      "type": "earned",
      "points": earnedPoints,
      "description": description,
      "date": DateTime.now(),
      "balance": _points,
    });

    _updateTier();
  }

  static bool redeemPoints(int points, String description) {
    if (points <= _points) {
      _points -= points;

      _pointsHistory.add({
        "type": "redeemed",
        "points": points,
        "description": description,
        "date": DateTime.now(),
        "balance": _points,
      });

      _updateTier();
      return true;
    }
    return false;
  }

  static List<Map<String, dynamic>> getPointsHistory() {
    return List.from(_pointsHistory.reversed);
  }

  // Convert points to BDT discount (100 points = 50 BDT)
  static double pointsToBDT(int points) {
    return points * 0.5;
  }

  static int bdtToPoints(double bdt) {
    return (bdt * 2).round();
  }

  // Bonus point events
  static void addBonusPoints(int points, String reason) {
    _points += points;

    _pointsHistory.add({
      "type": "bonus",
      "points": points,
      "description": reason,
      "date": DateTime.now(),
      "balance": _points,
    });

    _updateTier();
  }

  // Birthday bonus
  static void claimBirthdayBonus() {
    addBonusPoints(200, "Birthday Bonus 🎂");
  }

  // First purchase bonus
  static void claimFirstPurchaseBonus() {
    addBonusPoints(100, "First Purchase Bonus 🎉");
  }

  // Referral bonus
  static void claimReferralBonus(String referredUserName) {
    addBonusPoints(150, "Referral Bonus - $referredUserName joined!");
  }
}
