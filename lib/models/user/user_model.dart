import 'dart:convert';

class UserModel{
  final int? id;
  final String name;
  final String email;
  Map<int, int>? cart;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.cart
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      cart: json['cart'] != "null" 
        ? Map<int, int>.from(jsonDecode(json['cart'] as String)) 
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'cart': jsonEncode(cart),
    };
  }
}