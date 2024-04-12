class UserModel{
  final int id;
  final String name;
  final String email;
  Map<int, int>? cart;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.cart
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      cart: json['cart'],
    );
  }
}