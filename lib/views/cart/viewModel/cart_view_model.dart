import 'dart:convert';

import 'package:mobx/mobx.dart';

import '../../../core/managers/user/user_data_manager.dart';
import '../../../core/services/auth/i_auth_service.dart';
import '../../../core/services/product/i_product_service.dart';
import '../../../core/services/service_state.dart';
import '../../../core/utils/secure_storage_helper.dart';
import '../../../models/product/product_model.dart';
import '../../../models/user/user_model.dart';

part 'cart_view_model.g.dart';

class CartViewModel = CartViewModelBase with _$CartViewModel;

abstract class CartViewModelBase with Store {
  CartViewModelBase(this.productService, this.authService){
    fetchCartProductsService();
  }

  final IProductService productService;
  final IAuthService authService;

  @observable
  List<ProductModel> products = [];

  @observable
  ServiceState serviceState = ServiceState.normal;

  @observable
  String errorMessage = "An error has ocurred";

  @action
  Future<void> fetchCartProductsService() async {
    UserModel user = UserDataManager.user!;

    serviceState = ServiceState.loading;
    try {
      for (var i = 0; i < user.cart.length; i++) {
        products.add(await productService.fetchProduct(user.cart[i].productId));
      }
      
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
  void incrementQuantity(int index) {
    UserModel user = UserDataManager.user!;
    if (index >= 0 &&
        index < user.cart.length) {
      user.cart[index].quantity++;
    }
  }

  @action
  Future<void> decrementQuantity(int index) async {
    UserModel user = UserDataManager.user!;
    if (index >= 0 &&
        index < user.cart.length &&
        user.cart[index].quantity > 0) {
      user.cart[index].quantity--;
      if (user.cart[index].quantity == 0) {
        deleteItem(index);
      }
    }
  }

  @action
  Future<void> deleteItem(int index) async {
    UserModel user = UserDataManager.user!;
    if (index >= 0 && index < user.cart.length) {
      await authService.deleteUserCartItem(user.cart[index]);
      products.removeAt(index);
      user.cart.removeAt(index);
      updateUserService();
    }
  }

  @action
  double calulateTotal(){
    double total = 0.0;
    for (var item in products) {
      total += item.price * UserDataManager.user!.cart[products.indexOf(item)].quantity;
    }
    return total;
  }

  @action
  Future<void> checkOut() async{
    try {
      products.clear();

      UserModel user = UserDataManager.user!;
      for (var cartItem in user.cart) {
        await authService.deleteUserCartItem(cartItem);
      }
      user.cart.clear();

      updateUserService();

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
  Future<void> updateUserService() async {
    serviceState = ServiceState.loading;
    try {
      UserModel user = UserDataManager.user!;
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