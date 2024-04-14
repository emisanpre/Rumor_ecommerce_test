import 'dart:async';

import '../../../models/user/user_model.dart';
import '../sqlite/user_sqlite_service.dart';
import 'i_auth_service.dart';

class MockAuthService extends IAuthService{
  MockAuthService(super.dio);
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

      await _userSqliteService.insertUser(UserModel(name: name, email: email), password);
      UserModel? newUser = await _userSqliteService.user(email);
      return newUser!;
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
}