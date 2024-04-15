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

/// ViewModel for managing the user's shopping cart.
///
/// This class handles operations related to the user's shopping cart,
/// including fetching cart products, updating quantities, deleting items,
/// calculating total price, and checking out.
class CartViewModel = CartViewModelBase with _$CartViewModel;

abstract class CartViewModelBase with Store {
  /// Creates an instance of [CartViewModel].
  ///
  /// [productService]: Product service.
  /// [authService]: Authentication service.
  CartViewModelBase(this.productService, this.authService){
    fetchCartProductsService();
  }

  /// Product service used to fetch product details.
  final IProductService productService;

  /// Authentication service used to update user data.
  final IAuthService authService;

  /// List of products in the user's shopping cart.
  @observable
  List<ProductModel> products = [];

  /// State of the cart service.
  @observable
  ServiceState serviceState = ServiceState.normal;

  /// Error message displayed in case an error occurs during cart operations.
  @observable
  String errorMessage = "An error has ocurred";

  /// Fetches products in the user's shopping cart.
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

  /// Increments the quantity of a product in the cart.
  @action
  void incrementQuantity(int index) {
    UserModel user = UserDataManager.user!;
    if (index >= 0 &&
        index < user.cart.length) {
      user.cart[index].quantity++;
    }
  }

  /// Decrements the quantity of a product in the cart. 
  /// If quantity is less or equal than zero, deletes the product from shoppinng cart.
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

  /// Deletes an product from the cart.
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

  /// Calculates the total price of all products in the cart.
  @action
  double calulateTotal(){
    double total = 0.0;
    for (var item in products) {
      total += item.price * UserDataManager.user!.cart[products.indexOf(item)].quantity;
    }
    return total;
  }

  /// Simulates the check out of the items in the cart.
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

  /// Updates user data after cart changes.
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