// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProductViewModel on ProductViewModelBase, Store {
  late final _$userAtom =
      Atom(name: 'ProductViewModelBase.user', context: context);

  @override
  UserModel get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserModel value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$userCartAtom =
      Atom(name: 'ProductViewModelBase.userCart', context: context);

  @override
  ObservableList<CartItemModel>? get userCart {
    _$userCartAtom.reportRead();
    return super.userCart;
  }

  @override
  set userCart(ObservableList<CartItemModel>? value) {
    _$userCartAtom.reportWrite(value, super.userCart, () {
      super.userCart = value;
    });
  }

  late final _$quantityAtom =
      Atom(name: 'ProductViewModelBase.quantity', context: context);

  @override
  int get quantity {
    _$quantityAtom.reportRead();
    return super.quantity;
  }

  @override
  set quantity(int value) {
    _$quantityAtom.reportWrite(value, super.quantity, () {
      super.quantity = value;
    });
  }

  late final _$serviceStateAtom =
      Atom(name: 'ProductViewModelBase.serviceState', context: context);

  @override
  ServiceState get serviceState {
    _$serviceStateAtom.reportRead();
    return super.serviceState;
  }

  @override
  set serviceState(ServiceState value) {
    _$serviceStateAtom.reportWrite(value, super.serviceState, () {
      super.serviceState = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: 'ProductViewModelBase.errorMessage', context: context);

  @override
  String get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$updateUserCartServiceAsyncAction = AsyncAction(
      'ProductViewModelBase.updateUserCartService',
      context: context);

  @override
  Future<void> updateUserCartService() {
    return _$updateUserCartServiceAsyncAction
        .run(() => super.updateUserCartService());
  }

  @override
  String toString() {
    return '''
user: ${user},
userCart: ${userCart},
quantity: ${quantity},
serviceState: ${serviceState},
errorMessage: ${errorMessage}
    ''';
  }
}
