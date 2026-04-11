enum AppOrderStatus { pending, processing, shipped, delivered, cancelled, returned }

class AppOrder {
  final String id;
  final String userId;
  final String? storeId;
  final List<Map<String, dynamic>> items;
  final double subtotal;
  final double shippingFee;
  final double taxFee;
  final double discount;
  final double total;
  final String paymentMethod;
  final AppOrderStatus status;
  final String shippingAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AppOrder({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.taxFee,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.shippingAddress,
    this.storeId,
    this.createdAt,
    this.updatedAt,
  });

  factory AppOrder.fromJson(Map<String, dynamic> json) {
    return AppOrder(
      id: (json['id'] ?? '') as String,
      userId: (json['userId'] ?? json['user-id'] ?? '') as String,
      storeId: json['storeId'] as String?,
      items: (json['items'] as List?)?.cast<Map<String, dynamic>>() ?? const [],
      subtotal: _readDouble(json['subtotal']),
      shippingFee: _readDouble(json['shippingFee']),
      taxFee: _readDouble(json['taxFee']),
      discount: _readDouble(json['discount']),
      total: _readDouble(json['total']),
      paymentMethod: (json['paymentMethod'] ?? '') as String,
      status: _parseStatus(json['status']?.toString()),
      shippingAddress: (json['shippingAddress'] ?? '') as String,
      createdAt: _readDateTime(json['createdAt']),
      updatedAt: _readDateTime(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'storeId': storeId,
      'items': items,
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'taxFee': taxFee,
      'discount': discount,
      'total': total,
      'paymentMethod': paymentMethod,
      'status': status.name,
      'shippingAddress': shippingAddress,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static AppOrderStatus _parseStatus(String? value) {
    switch (value) {
      case 'processing':
        return AppOrderStatus.processing;
      case 'shipped':
        return AppOrderStatus.shipped;
      case 'delivered':
        return AppOrderStatus.delivered;
      case 'cancelled':
        return AppOrderStatus.cancelled;
      case 'returned':
        return AppOrderStatus.returned;
      default:
        return AppOrderStatus.pending;
    }
  }

  static double _readDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static DateTime? _readDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}