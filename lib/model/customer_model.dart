class CustomerModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String? phone;
  final String? barcode;
  final String? card;
  final DateTime lastVisit;
  final String userId;
  final int balance;
  final bool favorite;

  CustomerModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    this.phone,
    this.barcode,
    this.card,
    required this.lastVisit,
    required this.userId,
    required this.balance,
    required this.favorite,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      name: json['name'] as String,
      phone: json['phone'] as String?,
      barcode: json['barcode'] as String?,
      card: json['card'] as String?,
      lastVisit: DateTime.parse(json['last_visit']),
      userId: json['user_id'] as String,
      balance: json['balance'],
      favorite: json['favorite'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': createdAt.toIso8601String(),
      'name': name,
      'phone': phone,
      'barcode': barcode,
      'card': card,
      'last_visit': lastVisit.toIso8601String(),
      'user_id': userId,
      'balance': balance,
      'favorite': favorite,
    };
  }
}
