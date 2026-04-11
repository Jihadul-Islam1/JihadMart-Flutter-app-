class AppUser {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String role;
  final String? storeId;
  final String? gender;
  final String? dob;
  final String? age;
  final String? photoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AppUser({
    required this.id,
    required this.email,
    required this.role,
    this.name,
    this.phone,
    this.storeId,
    this.gender,
    this.dob,
    this.age,
    this.photoUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: (json['id'] ?? json['email'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      role: (json['role'] ?? 'customer') as String,
      storeId: json['storeId'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] as String?,
      age: json['age'] as String?,
      photoUrl: json['photoUrl'] as String?,
      createdAt: _readDateTime(json['createdAt']),
      updatedAt: _readDateTime(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      'storeId': storeId,
      'gender': gender,
      'dob': dob,
      'age': age,
      'photoUrl': photoUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? role,
    String? storeId,
    String? gender,
    String? dob,
    String? age,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      storeId: storeId ?? this.storeId,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      age: age ?? this.age,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _readDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}