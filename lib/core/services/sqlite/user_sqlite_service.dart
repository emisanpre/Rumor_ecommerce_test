import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../../models/cart_item/cart_item_model.dart';
import '../../../models/user/user_model.dart';
import '../../utils/encrypt.dart';
import 'sqlite_service.dart';

class UserSqliteService extends SqliteService{

  Future<UserModel?> user(String email) async {
    final db = await database;

    final List<Map<String, Object?>> userMaps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (userMaps.isNotEmpty) {
      final userMap = userMaps.first;
      final int userId = userMap['id'] as int;
      final String userName = userMap['name'] as String;
      final String userEmail = userMap['email'] as String;
      final dynamic userCartJson = userMap['cart'] as dynamic;

      List<CartItemModel>? userCart;
      if (userCartJson != "null") {
        userCart = [];
        jsonDecode(userCartJson).forEach((item) {
          userCart!.add(CartItemModel.fromJson(item));
        });
      }

      return UserModel(id: userId, name: userName, email: userEmail, cart: userCart);
    } else {
      return null;
    }
  }

  Future<List<UserModel>> users() async {
    final db = await database;

    final List<Map<String, Object?>> userMaps = await db.query('users');

    return userMaps.map((userMap) {
      final int userId = userMap['id'] as int;
      final String userName = userMap['name'] as String;
      final String userEmail = userMap['email'] as String;
      final dynamic userCartJson = userMap['cart'] as dynamic;

      List<CartItemModel>? userCart;
      if (userCartJson != "null") {
        userCart = [];
        jsonDecode(userCartJson).forEach((item) {
          userCart!.add(CartItemModel.fromJson(item));
        });
      }

      return UserModel(id: userId, name: userName, email: userEmail, cart: userCart);
    }).toList();
  }

  Future<void> insertUser(UserModel user, String password) async {
    final db = await database;

    Map<String, dynamic> userData = user.toJson();
    userData['password'] = Encrypt.encrypt(password);

    await db.insert(
      'users', 
      userData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUser(UserModel user, {String? password}) async {
    final db = await database;

    Map<String, dynamic> userData = user.toJson();

    if (password != null) {
      userData['password'] = Encrypt.encrypt(password);
    }

    await db.update(
      'users',
      userData,
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int id) async {
    final db = await database;

    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> verifyCredentials(String email, String password) async {
    final db = await database;

    final List<Map<String, Object?>> userMaps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (userMaps.isNotEmpty) {
      final String? hashedPassword = userMaps.first['password'] as String?;
      if (hashedPassword != null) {
        return Encrypt.verifyEncrypted(password, hashedPassword);
      }
    }

    return false;
  }
}