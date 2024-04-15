import 'dart:async';

import 'package:flutter/material.dart';

import '../../../models/cart_item/cart_item_model.dart';
import '../../../models/user/user_model.dart';
import '../sqlite/user_sqlite_service.dart';
import 'i_auth_service.dart';

class AuthService extends IAuthService{
  AuthService(super.dio);
  final UserSqliteService _userSqliteService = UserSqliteService();

  @override
  Future<UserModel> signIn(String email, String password) async {
    try{
      UserModel? user = await _userSqliteService.user(email);
      if(user != null){
        bool passwordCorrect = await _userSqliteService.verifyCredentials(email, password);
        if (passwordCorrect) {
          return user;
        } else {
          throw Exception('Incorrect password');
        }
      }
      else{
        throw Exception('User not found');
      }
    }
    catch (e){
      throw Exception('Failed to sign in: $e');
    } 
  }

  @override
  Future<UserModel> signUp(String name, String email, String password) async {
    try{
      UserModel? existingUser = await _userSqliteService.user(email);
      if(existingUser != null){
        throw Exception('User already exists');
      }

      UserModel newUser = UserModel(id: UniqueKey().toString(), name: name, email: email);
      await _userSqliteService.insertUser(newUser, password);

      return newUser;
    }
    catch (e){
      throw Exception('Failed to sign up: $e');
    } 
  }

  @override
  Future<void> logOut() async {
    //No implementation
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try{
      await _userSqliteService.updateUser(user);
    }
    catch (e){
      throw Exception('Failed to update user: $e');
    } 
  }

  @override
  Future<void> deleteUserCartItem(CartItemModel cartItem) async {
    try{
      await _userSqliteService.deleteCartItem(cartItem);
    }
    catch (e){
      throw Exception('Failed to delete cart item: $e');
    } 
  }
}