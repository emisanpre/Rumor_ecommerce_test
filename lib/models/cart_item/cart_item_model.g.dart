// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      id: json['id'] as int?,
      userId: json['userId'] as int,
      productId: json['productId'] as int,
      quantity: json['quantity'] as int,
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'productId': instance.productId,
      'quantity': instance.quantity,
    };

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CartItemModel on _CartItemModel, Store {
  late final _$idAtom = Atom(name: '_CartItemModel.id', context: context);

  @override
  int? get id {
    _$idAtom.reportRead();
    return super.id;
  }

  @override
  set id(int? value) {
    _$idAtom.reportWrite(value, super.id, () {
      super.id = value;
    });
  }

  late final _$userIdAtom =
      Atom(name: '_CartItemModel.userId', context: context);

  @override
  int get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(int value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  late final _$productIdAtom =
      Atom(name: '_CartItemModel.productId', context: context);

  @override
  int get productId {
    _$productIdAtom.reportRead();
    return super.productId;
  }

  @override
  set productId(int value) {
    _$productIdAtom.reportWrite(value, super.productId, () {
      super.productId = value;
    });
  }

  late final _$quantityAtom =
      Atom(name: '_CartItemModel.quantity', context: context);

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

  @override
  String toString() {
    return '''
id: ${id},
userId: ${userId},
productId: ${productId},
quantity: ${quantity}
    ''';
  }
}
