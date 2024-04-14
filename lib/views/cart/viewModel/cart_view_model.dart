import 'dart:convert';

import 'package:mobx/mobx.dart';

import '../../../core/services/auth/i_auth_service.dart';
import '../../../core/services/product/i_product_service.dart';
import '../../../core/services/service_state.dart';
import '../../../core/utils/secure_storage_helper.dart';
import '../../../models/cart_item/cart_item_model.dart';
import '../../../models/product/product_model.dart';
import '../../../models/user/user_model.dart';

part 'cart_view_model.g.dart';

class CartViewModel = CartViewModelBase with _$CartViewModel;

abstract class CartViewModelBase with Store {
  CartViewModelBase(this.productService, this.authService){
    _init();
  }

  final IProductService productService;
  final IAuthService authService;

  @observable
  UserModel user = UserModel(name: '', email: '');

  @observable
  ObservableList<CartItemModel>? userCart;

  @observable
  List<ProductModel> products = [];

  @observable
  ServiceState serviceState = ServiceState.normal;

  @observable
  String errorMessage = "An error has ocurred";

  @action
  Future<void> fetchCartProductsService() async {
    if(userCart == null){
      serviceState = ServiceState.success;
      return;
    } 

    serviceState = ServiceState.loading;
    try {
      for (var i = 0; i < userCart!.length; i++) {
        products.add(await productService.fetchProduct(userCart![i].productId));
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
    if (userCart != null &&
        index >= 0 &&
        index < userCart!.length) {
      userCart![index].quantity++;
    }
  }

  @action
  void decrementQuantity(int index) {
    if (userCart != null &&
        index >= 0 &&
        index < userCart!.length &&
        userCart![index].quantity > 0) {
      userCart![index].quantity--;
      if (userCart![index].quantity == 0) {
        products.removeAt(index);
        userCart!.removeAt(index);
      }
    }
  }

  @action
  Future<void> updateUserService() async {
    serviceState = ServiceState.loading;
    try {
      user.cart = userCart;
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

  Future<void> _init() async {
    String? userString = await SecureStorageHelper.getData(key: 'authUser');
    user = UserModel.fromJson(jsonDecode(userString!));
    if(user.cart != null){
      userCart = ObservableList.of(user.cart!);
    }
    fetchCartProductsService();
  }
}