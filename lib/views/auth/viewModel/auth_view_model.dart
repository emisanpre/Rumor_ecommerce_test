import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobx/mobx.dart';

import '../../../core/services/auth/i_auth_service.dart';
import '../../../core/services/service_state.dart';
import '../../../models/user/user_model.dart';

part 'auth_view_model.g.dart';

class AuthViewModel = AuthViewModelBase with _$AuthViewModel;

abstract class AuthViewModelBase with Store {
  AuthViewModelBase(this.authService){
    _init();
  }

  final IAuthService authService;
  late FlutterSecureStorage storage;

  @observable
  UserModel? user;

  @observable
  ServiceState serviceState = ServiceState.normal;
  
  @observable
  String errorMessage = "An error has ocurred";

  @action
  Future<void> signInService(String email, String password) async {
    serviceState = ServiceState.loading;
    try {
      user = await authService.signIn(email, password);
      String userJson = jsonEncode(user!.toJson());
      storage.write(key: 'authUser', value: userJson);

      serviceState = ServiceState.success;
    }on Exception catch (e) {
      errorMessage = e.toString().replaceAll('Exception:', '');
      serviceState = ServiceState.error;
    } catch (e) {
      errorMessage = e.toString();
      serviceState = ServiceState.error;
    }
  }

  @action
  Future<void> signUpService(String name, String email, String password) async {
    serviceState = ServiceState.loading;
    try {
      user = await authService.signUp(name, email, password);
      storage.write(key: 'authUser', value: user!.toJson().toString());
      
      serviceState = ServiceState.success;
    } on Exception catch (e) {
      errorMessage = e.toString().replaceAll('Exception:', '');
      serviceState = ServiceState.error;
    } catch (e) {
      errorMessage = e.toString();
      serviceState = ServiceState.error;
    }
  }

  Future<void> _init() async {
    storage = const FlutterSecureStorage(
      aOptions:  AndroidOptions(
        encryptedSharedPreferences: true,
      )
    );
    String? userString = await storage.read(key: 'authUser');
    userString != null 
      ? user = UserModel.fromJson(jsonDecode(userString))
      : user = null;
  }
}