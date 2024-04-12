import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobx/mobx.dart';

import '../../../core/services/auth/i_auth_service.dart';
import '../../../core/services/product/i_product_service.dart';
import '../../../core/services/service_state.dart';
import '../../../models/product/product_model.dart';
import '../../../models/user/user_model.dart';

part 'home_view_model.g.dart';

class HomeViewModel = HomeViewModelBase with _$HomeViewModel;

abstract class HomeViewModelBase with Store {
  HomeViewModelBase(this.productService, this.authService){
    _init();
  }

  final IProductService productService;
  final IAuthService authService;
  late FlutterSecureStorage storage;

  @observable
  UserModel user = UserModel(name: '', email: '');

  @observable
  List<ProductModel> products = [];

  @observable
  ServiceState serviceState = ServiceState.normal;

  @observable
  String errorMessage = "An error has ocurred";

  @action
  Future<void> fetchAllProductService() async {
    serviceState = ServiceState.loading;
    try {
      products = await productService.fetchProducts();
      serviceState = ServiceState.success;
    } on Exception catch (e) {
      errorMessage = e.toString().replaceAll('Exception:', '');
      serviceState = ServiceState.error;
    } catch (e) {
      errorMessage = e.toString();
      serviceState = ServiceState.error;
    }
  }

  @action
  Future<void> logOutService() async {
    serviceState = ServiceState.loading;
    try {
      await authService.logOut();
      storage.delete(key: 'authUser');

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
    user = UserModel.fromJson(jsonDecode(userString!));
  }
}