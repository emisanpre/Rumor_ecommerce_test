// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CartViewModel on CartViewModelBase, Store {
  late final _$productsAtom =
      Atom(name: 'CartViewModelBase.products', context: context);

  @override
  List<ProductModel> get products {
    _$productsAtom.reportRead();
    return super.products;
  }

  @override
  set products(List<ProductModel> value) {
    _$productsAtom.reportWrite(value, super.products, () {
      super.products = value;
    });
  }

  late final _$serviceStateAtom =
      Atom(name: 'CartViewModelBase.serviceState', context: context);

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
      Atom(name: 'CartViewModelBase.errorMessage', context: context);

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

  late final _$fetchCartProductsServiceAsyncAction = AsyncAction(
      'CartViewModelBase.fetchCartProductsService',
      context: context);

  @override
  Future<void> fetchCartProductsService() {
    return _$fetchCartProductsServiceAsyncAction
        .run(() => super.fetchCartProductsService());
  }

  late final _$updateUserServiceAsyncAction =
      AsyncAction('CartViewModelBase.updateUserService', context: context);

  @override
  Future<void> updateUserService() {
    return _$updateUserServiceAsyncAction.run(() => super.updateUserService());
  }

  late final _$CartViewModelBaseActionController =
      ActionController(name: 'CartViewModelBase', context: context);

  @override
  void incrementQuantity(int index) {
    final _$actionInfo = _$CartViewModelBaseActionController.startAction(
        name: 'CartViewModelBase.incrementQuantity');
    try {
      return super.incrementQuantity(index);
    } finally {
      _$CartViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decrementQuantity(int index) {
    final _$actionInfo = _$CartViewModelBaseActionController.startAction(
        name: 'CartViewModelBase.decrementQuantity');
    try {
      return super.decrementQuantity(index);
    } finally {
      _$CartViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
products: ${products},
serviceState: ${serviceState},
errorMessage: ${errorMessage}
    ''';
  }
}
