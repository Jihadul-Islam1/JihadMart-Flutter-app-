class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  final List<Map<String, dynamic>> _orders = [
    {
      'orderId': '#ORD-2025-001',
      'date': 'Dec 1, 2025',
      'status': 'Processing',
      'total': 7500.0,
      'paymentMethod': 'Cash on Delivery',
      'items': [
        {
          'name': 'Nike Air Max Pro',
          'image': 'assets/products/product1.jpg',
          'price': 7500.0,
          'quantity': 1,
        },
      ],
    },
    {
      'orderId': '#ORD-2025-002',
      'date': 'Nov 28, 2025',
      'status': 'Shipped',
      'total': 13200.0,
      'paymentMethod': 'bKash',
      'items': [
        {
          'name': 'Adidas Ultraboost 22',
          'image': 'assets/products/product2.jpg',
          'price': 13200.0,
          'quantity': 1,
        },
      ],
    },
    {
      'orderId': '#ORD-2025-003',
      'date': 'Nov 25, 2025',
      'status': 'Delivered',
      'total': 2500.0,
      'paymentMethod': 'Nagad',
      'items': [
        {
          'name': 'Smart Watch Strap',
          'image': 'assets/products/product5.jpg',
          'price': 2500.0,
          'quantity': 1,
        },
      ],
    },
  ];

  List<Map<String, dynamic>> get orders => _orders;

  void placeOrder(Map<String, dynamic> order) {
    _orders.insert(0, order); // Add new order to the top
  }
}
