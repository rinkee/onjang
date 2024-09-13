class UserModel {
  final DateTime createdAt;
  final String name;
  final String storeName;
  final String email;
  final String password;
  final DateTime lastLogin;
  final String uid;
  final String phone;
  final String certificationPassword;
  final int addRatio;

  UserModel(
      {required this.createdAt,
      required this.name,
      required this.storeName,
      required this.email,
      required this.password,
      required this.lastLogin,
      required this.uid,
      required this.phone,
      required this.certificationPassword,
      required this.addRatio});

  // Factory constructor for creating a new UserModel instance from a map.
  // Use this for JSON deserialization.
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      createdAt: DateTime.parse(json['created_at']),
      name: json['name'] ?? '',
      storeName: json['store_name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'], // Ensure to securely handle the password.
      lastLogin: DateTime.parse(json['last_login']),
      uid: json['uid'],
      phone: json['phone'] ?? '',
      certificationPassword: json['certification_password'],
      addRatio: json['add_ratio']);

  // Method for serializing UserModel instance to a map.
  // Use this for JSON serialization.
  Map<String, dynamic> toJson() => {
        'created_at': createdAt.toIso8601String(),
        'name': name,
        'store_name': storeName,
        'email': email,
        'password': password, // Be cautious with password handling.
        'last_login': lastLogin.toIso8601String(),
        'uid': uid,
        'phone': phone,
        'certificationPassword': certificationPassword,
        'addRatio': addRatio,
      };
}
