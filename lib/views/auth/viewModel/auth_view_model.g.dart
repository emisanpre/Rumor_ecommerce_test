// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthViewModel on AuthViewModelBase, Store {
  late final _$userAtom =
      Atom(name: 'AuthViewModelBase.user', context: context);

  @override
  UserModel? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserModel? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$serviceStateAtom =
      Atom(name: 'AuthViewModelBase.serviceState', context: context);

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
      Atom(name: 'AuthViewModelBase.errorMessage', context: context);

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

  late final _$signInServiceAsyncAction =
      AsyncAction('AuthViewModelBase.signInService', context: context);

  @override
  Future<void> signInService(String email, String password) {
    return _$signInServiceAsyncAction
        .run(() => super.signInService(email, password));
  }

  late final _$signUpServiceAsyncAction =
      AsyncAction('AuthViewModelBase.signUpService', context: context);

  @override
  Future<void> signUpService(String name, String email, String password) {
    return _$signUpServiceAsyncAction
        .run(() => super.signUpService(name, email, password));
  }

  @override
  String toString() {
    return '''
user: ${user},
serviceState: ${serviceState},
errorMessage: ${errorMessage}
    ''';
  }
}
