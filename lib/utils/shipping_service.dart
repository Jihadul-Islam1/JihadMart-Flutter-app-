// Shipping & Delivery Service
class ShippingService {
  static List<Map<String, dynamic>> _shippingMethods = [
    {
      'id': 'standard',
      'name': 'Standard Delivery',
      'description': '5-7 working days',
      'price': 60.0,
      'freeAbove': 1000.0,
      'icon': '📦',
    },
    {
      'id': 'express',
      'name': 'Express Delivery',
      'description': '2-3 working days',
      'price': 120.0,
      'freeAbove': 3000.0,
      'icon': '🚀',
    },
    {
      'id': 'sameday',
      'name': 'Same Day Delivery',
      'description': 'Delivery within 24 hours',
      'price': 250.0,
      'freeAbove': 5000.0,
      'icon': '⚡',
    },
    {
      'id': 'scheduled',
      'name': 'Scheduled Delivery',
      'description': 'Choose your preferred date & time',
      'price': 100.0,
      'freeAbove': 2000.0,
      'icon': '📅',
    },
    {
      'id': 'pickup',
      'name': 'Store Pickup',
      'description': 'Free pickup from nearest store',
      'price': 0.0,
      'freeAbove': 0.0,
      'icon': '🏪',
    },
  ];

  static List<Map<String, dynamic>> _deliveryPartners = [
    {'name': 'Pathao', 'rating': 4.5, 'deliveries': '50K+'},
    {'name': 'Paperfly', 'rating': 4.3, 'deliveries': '30K+'},
    {'name': 'RedX', 'rating': 4.2, 'deliveries': '25K+'},
    {'name': 'eCourier', 'rating': 4.4, 'deliveries': '40K+'},
    {'name': 'Sundarban', 'rating': 4.1, 'deliveries': '20K+'},
  ];

  static List<Map<String, dynamic>> getShippingMethods() => _shippingMethods;
  static List<Map<String, dynamic>> getDeliveryPartners() => _deliveryPartners;

  static double calculateShipping(double orderTotal, String methodId) {
    var method = _shippingMethods.firstWhere((m) => m['id'] == methodId);
    if (orderTotal >= (method['freeAbove'] as double)) {
      return 0.0;
    }
    return method['price'] as double;
  }

  static Map<String, dynamic> getEstimatedDelivery(String methodId) {
    DateTime now = DateTime.now();
    switch (methodId) {
      case 'sameday':
        return {'min': now, 'max': now.add(Duration(hours: 24))};
      case 'express':
        return {
          'min': now.add(Duration(days: 2)),
          'max': now.add(Duration(days: 3)),
        };
      case 'scheduled':
        return {
          'min': now.add(Duration(days: 1)),
          'max': now.add(Duration(days: 7)),
        };
      default:
        return {
          'min': now.add(Duration(days: 5)),
          'max': now.add(Duration(days: 7)),
        };
    }
  }

  static List<Map<String, dynamic>> getScheduleSlots(DateTime date) {
    return [
      {'time': '9:00 AM - 12:00 PM', 'available': true},
      {'time': '12:00 PM - 3:00 PM', 'available': true},
      {'time': '3:00 PM - 6:00 PM', 'available': false},
      {'time': '6:00 PM - 9:00 PM', 'available': true},
    ];
  }
}

// Installment / EMI Service
class InstallmentService {
  static List<Map<String, dynamic>> _emiOptions = [
    {
      'months': 3,
      'interestRate': 0.0,
      'processingFee': 0.0,
      'banks': ['BRAC Bank', 'City Bank', 'EBL'],
      'minAmount': 5000.0,
    },
    {
      'months': 6,
      'interestRate': 0.0,
      'processingFee': 200.0,
      'banks': ['BRAC Bank', 'City Bank', 'EBL', 'DBBL'],
      'minAmount': 10000.0,
    },
    {
      'months': 9,
      'interestRate': 5.0,
      'processingFee': 300.0,
      'banks': ['BRAC Bank', 'City Bank', 'DBBL', 'Prime Bank'],
      'minAmount': 15000.0,
    },
    {
      'months': 12,
      'interestRate': 8.0,
      'processingFee': 500.0,
      'banks': ['BRAC Bank', 'City Bank', 'EBL', 'DBBL', 'Prime Bank', 'UCB'],
      'minAmount': 20000.0,
    },
    {
      'months': 18,
      'interestRate': 10.0,
      'processingFee': 700.0,
      'banks': ['BRAC Bank', 'City Bank', 'EBL'],
      'minAmount': 30000.0,
    },
    {
      'months': 24,
      'interestRate': 12.0,
      'processingFee': 1000.0,
      'banks': ['BRAC Bank', 'City Bank'],
      'minAmount': 50000.0,
    },
  ];

  static List<Map<String, dynamic>> _activeEMIs = [
    {
      'id': 'emi1',
      'orderId': 'ORD-2024-001',
      'product': 'Samsung Galaxy S24 Ultra',
      'totalAmount': 150000.0,
      'months': 12,
      'monthlyAmount': 13500.0,
      'paidMonths': 3,
      'remainingAmount': 121500.0,
      'bank': 'BRAC Bank',
      'startDate': DateTime.now().subtract(Duration(days: 90)),
      'nextDueDate': DateTime.now().add(Duration(days: 15)),
    },
  ];

  static List<Map<String, dynamic>> getEMIOptions() => _emiOptions;
  static List<Map<String, dynamic>> getActiveEMIs() => _activeEMIs;

  static List<Map<String, dynamic>> getAvailableEMIs(double amount) {
    return _emiOptions
        .where((e) => amount >= (e['minAmount'] as double))
        .toList();
  }

  static Map<String, dynamic> calculateEMI(double amount, int months) {
    var option = _emiOptions.firstWhere(
      (e) => e['months'] == months,
      orElse: () => _emiOptions.first,
    );

    double interest = amount * (option['interestRate'] as double) / 100;
    double totalAmount =
        amount + interest + (option['processingFee'] as double);
    double monthlyAmount = totalAmount / months;

    return {
      'principal': amount,
      'interest': interest,
      'processingFee': option['processingFee'],
      'totalAmount': totalAmount,
      'monthlyAmount': monthlyAmount,
      'months': months,
    };
  }

  static bool applyForEMI(String orderId, int months, String bank) {
    _activeEMIs.add({
      'id': 'emi_${DateTime.now().millisecondsSinceEpoch}',
      'orderId': orderId,
      'months': months,
      'bank': bank,
      'startDate': DateTime.now(),
      'status': 'pending_approval',
    });
    return true;
  }
}

// Insurance Service for Products
class InsuranceService {
  static List<Map<String, dynamic>> _plans = [
    {
      'id': 'basic',
      'name': 'Basic Protection',
      'coverage': ['Manufacturing Defects', 'Component Failure'],
      'duration': 12, // months
      'pricePercent': 5.0, // % of product price
      'maxClaim': 50000.0,
    },
    {
      'id': 'standard',
      'name': 'Standard Protection',
      'coverage': [
        'Manufacturing Defects',
        'Component Failure',
        'Accidental Damage',
        'Water Damage',
      ],
      'duration': 24,
      'pricePercent': 8.0,
      'maxClaim': 100000.0,
    },
    {
      'id': 'premium',
      'name': 'Premium Protection',
      'coverage': [
        'Manufacturing Defects',
        'Component Failure',
        'Accidental Damage',
        'Water Damage',
        'Theft',
        'Screen Damage',
      ],
      'duration': 36,
      'pricePercent': 12.0,
      'maxClaim': 200000.0,
    },
  ];

  static List<Map<String, dynamic>> _activePolicies = [
    {
      'id': 'pol1',
      'product': 'iPhone 15 Pro Max',
      'plan': 'Premium Protection',
      'startDate': DateTime.now().subtract(Duration(days: 60)),
      'endDate': DateTime.now().add(Duration(days: 1035)),
      'status': 'active',
      'claimsRemaining': 2,
    },
  ];

  static List<Map<String, dynamic>> getPlans() => _plans;
  static List<Map<String, dynamic>> getActivePolicies() => _activePolicies;

  static double calculatePremium(double productPrice, String planId) {
    var plan = _plans.firstWhere((p) => p['id'] == planId);
    return productPrice * (plan['pricePercent'] as double) / 100;
  }

  static bool fileClaim(String policyId, String reason, String description) {
    return true; // Claim filed successfully
  }
}
