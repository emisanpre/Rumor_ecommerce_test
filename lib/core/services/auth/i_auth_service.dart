import 'package:dio/dio.dart';

import '../../../models/user/user_model.dart';

abstract class IAuthService {
  IAuthService(this.dio);
  final Dio dio;

  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String name, String email, String password);
  Future<void> logOut();
}