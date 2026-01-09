// lib/utils/wallet_service.dart
class WalletService {
  static double _balance = 2500.0;
  static final List<Map<String, dynamic>> _transactions = [
    {
      'type': 'credit',
      'amount': 5000.0,
      'description': 'Added via bKash',
      'date': '2025-11-30 10:30',
    },
    {
      'type': 'debit',
      'amount': 2500.0,
      'description': 'Purchase #ORD-2025-003',
      'date': '2025-11-25 14:20',
    },
    {
      'type': 'cashback',
      'amount': 150.0,
      'description': 'Cashback for order #ORD-2025-002',
      'date': '2025-11-28 16:45',
    },
  ];

  static double getBalance() {
    return _balance;
  }

  static List<Map<String, dynamic>> getTransactions() {
    return _transactions;
  }

  static void addMoney(double amount, String method) {
    _balance += amount;
    _transactions.insert(0, {
      'type': 'credit',
      'amount': amount,
      'description': 'Added via $method',
      'date': DateTime.now().toString().substring(0, 16),
    });
  }

  static bool deductMoney(double amount, String description) {
    if (_balance >= amount) {
      _balance -= amount;
      _transactions.insert(0, {
        'type': 'debit',
        'amount': amount,
        'description': description,
        'date': DateTime.now().toString().substring(0, 16),
      });
      return true;
    }
    return false;
  }

  static void addCashback(double amount, String orderId) {
    _balance += amount;
    _transactions.insert(0, {
      'type': 'cashback',
      'amount': amount,
      'description': 'Cashback for order $orderId',
      'date': DateTime.now().toString().substring(0, 16),
    });
  }

  static void addRefund(double amount, String orderId) {
    _balance += amount;
    _transactions.insert(0, {
      'type': 'refund',
      'amount': amount,
      'description': 'Refund for order $orderId',
      'date': DateTime.now().toString().substring(0, 16),
    });
  }
}
