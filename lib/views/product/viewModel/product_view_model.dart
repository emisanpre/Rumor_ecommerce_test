import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../core/managers/user/user_data_manager.dart';
import '../../../core/services/auth/i_auth_service.dart';
import '../../../core/services/service_state.dart';
import '../../../core/utils/secure_storage_helper.dart';
import '../../../models/cart_item/cart_item_model.dart';
import '../../../models/product/product_model.dart';
import '../../../models/user/user_model.dart';

part 'product_view_model.g.dart';

class ProductViewModel = ProductViewModelBase with _$ProductViewModel;

abstract class ProductViewModelBase with Store {
  ProductViewModelBase(this.authService, this.product);

  final IAuthService authService;
  final ProductModel product;

  @observable
  int quantity = 1;

  @observable
  ServiceState serviceState = ServiceState.normal;

  @observable
  String errorMessage = "An error has ocurred";

  @action
  Future<void> updateUserCartService() async {
    UserModel user = UserDataManager.user!;
    serviceState = ServiceState.loading;
    try {
      CartItemModel? cartItem =  user.cart.where((cartItem) => cartItem.productId == product.id).firstOrNull;
      if (cartItem != null) {
        cartItem.quantity += quantity;
      }
      else{
        user.cart.add(CartItemModel(id: UniqueKey().toString(), userId: user.id, productId: product.id, quantity: quantity));
      }
      
      await authService.updateUser(user);
      String userJson = jsonEncode(user.toJson());
      SecureStorageHelper.saveData(key: 'authUser', value: userJson);
      
      serviceState = ServiceState.success;
    } on Exception catch (e) {
      errorMessage = e.toString().replaceAll('Exception:', '');
      serviceState = ServiceState.error;
    } catch (e) {
      errorMessage = e.toString();
      serviceState = ServiceState.error;
    }
  }
}