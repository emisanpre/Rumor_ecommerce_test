import 'dart:convert';

import '../cart_item/cart_item_model.dart';

class UserModel{
  final int? id;
  final String name;
  final String email;
  List<CartItemModel>? cart;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.cart
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<CartItemModel>? parsedCart;
    if (json['cart'] != "null") {
      parsedCart = [];
      jsonDecode(json['cart']).forEach((item) {
        parsedCart!.add(CartItemModel.fromJson(item));
      });
    }

    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      cart: parsedCart,
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