import 'package:dio/dio.dart';

import '../../../models/cart_item/cart_item_model.dart';
import '../../../models/user/user_model.dart';

/// Interface for authentication service.
///
/// This interface defines methods for user authentication operations,
/// such as signing in, signing up, logging out, updating user information,
/// and deleting user cart items.
abstract class IAuthService {
  /// Creates an instance of [IAuthService].
  ///
  /// [dio]: Dio instance for HTTP requests.
  IAuthService(this.dio);

  /// Dio instance used for HTTP requests.
  final Dio dio;

  /// Signs in a user with the provided email and password.
  ///
  /// Returns a [UserModel] representing the authenticated user.
  Future<UserModel> signIn(String email, String password);

  /// Registers a new user with the provided name, email, and password.
  ///
  /// Returns a [UserModel] representing the registered user.
  Future<UserModel> signUp(String name, String email, String password);

  /// Logs out the currently authenticated user.
  ///
  /// This operation clears the authentication session.
  Future<void> logOut();

  /// Updates the information of the authenticated user.
  ///
  /// [user]: Updated user information represented by a [UserModel].
  Future<void> updateUser(UserModel user);

  /// Deletes a cart item associated with the authenticated user.
  ///
  /// [cartItem]: Cart item to be deleted represented by a [CartItemModel].
  Future<void> deleteUserCartItem(CartItemModel cartItem);
}