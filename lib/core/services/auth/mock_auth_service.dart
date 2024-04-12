import 'dart:async';

import '../../../models/user/user_model.dart';
import 'i_auth_service.dart';

class MockAuthService extends IAuthService{
  MockAuthService(super.dio);

  @override
  Future<UserModel> signIn(String email, String password) async {

    await Future.delayed(const Duration(seconds: 1));

    return UserModel(id: 1, name: "Test", email: email);
  }

  @override
  Future<UserModel> register(String email, String password) async {

    await Future.delayed(const Duration(seconds: 1));

    return UserModel(id: 1, name: "Test", email: email);
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<bool> isSignedIn() async {
    await Future.delayed(const Duration(seconds: 1));

    return true;
  }
}