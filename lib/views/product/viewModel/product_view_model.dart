import 'dart:convert';

import 'package:mobx/mobx.dart';

import '../../../core/services/auth/i_auth_service.dart';
import '../../../core/services/service_state.dart';
import '../../../core/utils/secure_storage_helper.dart';
import '../../../models/cart_item/cart_item_model.dart';
import '../../../models/product/product_model.dart';
import '../../../models/user/user_model.dart';

part 'product_view_model.g.dart';

class ProductViewModel = ProductViewModelBase with _$ProductViewModel;

abstract class ProductViewModelBase with Store {
  ProductViewModelBase(this.authService, this.product){
    _init();
  }

  final IAuthService authService;
  final ProductModel product;

  @observable
  UserModel user = UserModel(name: '', email: '');

  @observable
  ObservableList<CartItemModel>? userCart;

  @observable
  int quantity = 1;

  @observable
  ServiceState serviceState = ServiceState.normal;

  @observable
  String errorMessage = "An error has ocurred";

  @action
  Future<void> updateUserCartService() async {
    serviceState = ServiceState.loading;
    try {
      if (userCart != null) {
        CartItemModel? cartItem =  userCart!.where((cartItem) => cartItem.productId == product.id).firstOrNull;
        if (cartItem != null) {
          cartItem.quantity += quantity;
        }
        else{
          userCart!.add(CartItemModel(productId: product.id, quantity: quantity));
        }
      }
      else{
        userCart = ObservableList.of([
          CartItemModel(productId: product.id, quantity: quantity)
        ]);
      }
      
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
  }
}