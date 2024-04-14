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
      final editableUserMap = Map.of(userMap);

      final List<Map<String, Object?>> cartMaps = await db.query(
        'cartItems',
        where: 'userId = ?',
        whereArgs: [editableUserMap['id']],
      );

      List<dynamic> userCart = [];
      if(cartMaps.isNotEmpty){
        for (final cartMap in cartMaps) {
          userCart.add(cartMap);
        }
        editableUserMap['cart'] = userCart;
      }
      
      return UserModel.fromJson(editableUserMap);
    } else {
      return null;
    }
  }

  Future<void> insertUser(UserModel user, String password) async {
    final db = await database;

    Map<String, dynamic> userData = user.toJson();
    userData['password'] = Encrypt.encrypt(password);

    for (final cartItem in userData['cart']) {
      await db.insert(
        'cartItems', 
        cartItem,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    userData.remove('cart');
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

    for (final cartItem in userData['cart']) {
      var existingItem = await db.query(
        'cartItems',
        where: 'id = ?',
        whereArgs: [cartItem.id],
      );

      if (existingItem.isNotEmpty) {
        await db.update(
          'cartItems', 
          cartItem.toJson(),
          where: 'id = ?',
          whereArgs: [cartItem.id]
        );
      } else {
        await db.insert(
          'cartItems',
          cartItem.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace
        );
      }
    }

    userData.remove('cart');
    await db.update(
      'users',
      userData,
      where: 'id = ?',
      whereArgs: [user.id],
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
      final String hashedPassword = userMaps.first['password'] as String;
      return Encrypt.verifyEncrypted(password, hashedPassword);
    }

    return false;
  }
}