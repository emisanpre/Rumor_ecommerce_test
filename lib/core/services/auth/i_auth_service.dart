import 'package:dio/dio.dart';

import '../../../models/user/user_model.dart';

abstract class IAuthService {
  IAuthService(this.dio);
  final Dio dio;

  Future<UserModel> signIn(String email, String password);
  Future<UserModel> register(String email, String password);
  Future<void> signOut();
  Future<bool> isSignedIn();
}