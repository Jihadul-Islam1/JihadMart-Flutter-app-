class ProductItem {
  final String id;
  final String storeId;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String? category;
  final String? brand;
  final int stock;
  final String status;
  final Map<String, dynamic>? variants;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductItem({
    required this.id,
    required this.storeId,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.stock,
    required this.status,
    this.category,
    this.brand,
    this.variants,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'] ?? json['product-img'] ?? const <String>[];
    final imageList = rawImages is List
        ? rawImages.map((item) => item.toString()).toList()
        : <String>[rawImages.toString()];

    return ProductItem(
      id: (json['id'] ?? '') as String,
      storeId: (json['storeId'] ?? '') as String,
      name: (json['name'] ?? json['product-name'] ?? '') as String,
      description: (json['description'] ?? json['product-description'] ?? '')
          as String,
      price: _readDouble(json['price'] ?? json['product-price']),
      images: imageList,
      category: json['category'] as String?,
      brand: json['brand'] as String?,
      stock: _readInt(json['stock'], fallback: 0),
      status: (json['status'] ?? 'active') as String,
      variants: json['variants'] as Map<String, dynamic>?,
      createdAt: _readDateTime(json['createdAt']),
      updatedAt: _readDateTime(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'category': category,
      'brand': brand,
      'stock': stock,
      'status': status,
      'variants': variants,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static double _readDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int _readInt(dynamic value, {required int fallback}) {
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? fallback;
  }

  static DateTime? _readDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}