import 'package:get/get.dart';

class CTMState {
  static const String active = 'active';
  static const String unActive = 'unActive';
  static const String delete = 'delete';
}

class CustomerModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String companyName;
  final String name;
  final String? phone;
  final String? barcode;
  final String? card;
  final DateTime lastVisit;
  final String userId;
  String state;
  int balance;
  bool favorite;
  RxList? log;
  final bool useSignature;

  CustomerModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.companyName,
    required this.name,
    this.phone,
    this.barcode,
    this.card,
    required this.lastVisit,
    required this.userId,
    required this.balance,
    required this.favorite,
    required this.state,
    this.log,
    required this.useSignature,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      companyName: json['company_name'] ?? '',
      name: json['name'] as String,
      phone: json['phone'] as String?,
      barcode: json['barcode'] as String?,
      card: json['card'] as String?,
      lastVisit: DateTime.parse(json['last_visit']),
      userId: json['user_id'] as String,
      balance: json['balance'],
      favorite: json['favorite'] as bool,
      state: json['state'] as String,
      useSignature: json['use_signature'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': createdAt.toIso8601String(),
      'company_name': companyName,
      'name': name,
      'phone': phone,
      'barcode': barcode,
      'card': card,
      'last_visit': lastVisit.toIso8601String(),
      'user_id': userId,
      'balance': balance,
      'favorite': favorite,
      'state': state,
      'use_signature': useSignature,
    };
  }
}
