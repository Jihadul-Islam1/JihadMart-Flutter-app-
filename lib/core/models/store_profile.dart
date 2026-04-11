class StoreProfile {
  final String id;
  final String ownerId;
  final String ownerEmail;
  final String name;
  final String slug;
  final String? description;
  final String? logoUrl;
  final String status;
  final String? phone;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StoreProfile({
    required this.id,
    required this.ownerId,
    required this.ownerEmail,
    required this.name,
    required this.slug,
    required this.status,
    this.description,
    this.logoUrl,
    this.phone,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreProfile.fromJson(Map<String, dynamic> json) {
    return StoreProfile(
      id: (json['id'] ?? '') as String,
      ownerId: (json['ownerId'] ?? '') as String,
      ownerEmail: (json['ownerEmail'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      slug: (json['slug'] ?? '') as String,
      status: (json['status'] ?? 'active') as String,
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      createdAt: _readDateTime(json['createdAt']),
      updatedAt: _readDateTime(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'ownerEmail': ownerEmail,
      'name': name,
      'slug': slug,
      'description': description,
      'logoUrl': logoUrl,
      'status': status,
      'phone': phone,
      'address': address,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static DateTime? _readDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}