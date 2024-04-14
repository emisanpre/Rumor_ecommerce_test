import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
class CartItemModel extends _CartItemModel with _$CartItemModel {
  CartItemModel({
    int? id,
    required int userId,
    required int productId,
    required int quantity,
  }){
    if (id != null) this.id = id;
    this.userId = userId;
    this.productId = productId;
    this.quantity = quantity;
  }
  factory CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);
}

abstract class _CartItemModel with Store {
  @observable
  int? id = 0;

  @observable
  int userId = 0;

  @observable
  int productId = 0;

  @observable
  int quantity = 0;
}