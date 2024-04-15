import 'dart:convert';

import 'package:mobx/mobx.dart';

import '../../../core/managers/user/user_data_manager.dart';
import '../../../core/services/auth/i_auth_service.dart';
import '../../../core/services/service_state.dart';
import '../../../core/utils/secure_storage_helper.dart';
import '../../../models/user/user_model.dart';

part 'auth_view_model.g.dart';

/// ViewModel for user authentication management.
///
/// This class handles logic related to user authentication,
/// including login and registration, as well as authentication state
/// and potential errors.
class AuthViewModel = AuthViewModelBase with _$AuthViewModel;

abstract class AuthViewModelBase with Store {

  /// Creates an instance of [AuthViewModel].
  ///
  /// [authService]: Authentication service.
  AuthViewModelBase(this.authService){
    _init();
  }

  /// Authentication service used to perform auth operations.
  final IAuthService authService;

  /// Indicates whether the user is authenticated or not.
  @observable
  bool isAuth = false;

  /// Authentication service state.
  @observable
  ServiceState serviceState = ServiceState.normal;
  
  /// Error message displayed in case an error occurs during the authentication process.
  @observable
  String errorMessage = "An error has ocurred";

  /// Performs user login using the provided email and password.
  ///
  /// [email]: User's email.
  /// [password]: User's password.
  @action
  Future<void> signInService(String email, String password) async {
    serviceState = ServiceState.loading;
    try {
      UserDataManager.user = await authService.signIn(email, password);
      String userJson = jsonEncode(UserDataManager.user!.toJson());
      SecureStorageHelper.saveData(key: 'authUser', value: userJson);

      isAuth = true;

      serviceState = ServiceState.success;
    }on Exception catch (e) {
      errorMessage = e.toString().replaceAll('Exception:', '');
      serviceState = ServiceState.error;
    } catch (e) {
      errorMessage = e.toString();
      serviceState = ServiceState.error;
    }
  }

  /// Registers a new user using the provided name, email, and password.
  ///
  /// [name]: User's name.
  /// [email]: User's email.
  /// [password]: User's password.
  @action
  Future<void> signUpService(String name, String email, String password) async {
    serviceState = ServiceState.loading;
    try {
      UserDataManager.user = await authService.signUp(name, email, password);
      String userJson = jsonEncode(UserDataManager.user!.toJson());
      SecureStorageHelper.saveData(key: 'authUser', value: userJson);
      
      isAuth = true;
      
      serviceState = ServiceState.success;
    } on Exception catch (e) {
      errorMessage = e.toString().replaceAll('Exception:', '');
      serviceState = ServiceState.error;
    } catch (e) {
      errorMessage = e.toString();
      serviceState = ServiceState.error;
    }
  }

  /// Initializes the ViewModel state, loading the authenticated user if it exists.
  Future<void> _init() async {
    String? userString = await SecureStorageHelper.getData(key: 'authUser');
    userString != null 
      ? UserDataManager.user = UserModel.fromJson(jsonDecode(userString))
      : UserDataManager.user = null;

    if(UserDataManager.user != null){
      isAuth = true;
    }
  }
}