import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

import '../cart_item/cart_item_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends _UserModel with _$UserModel {
  UserModel({
    int? id,
    required String name,
    required String email,
    List<CartItemModel>? cart
  }){
    if (id != null) this.id = id;
    this.name = name;
    this.email = email;
    if (cart != null) this.cart = ObservableList.of(cart);
  }
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

abstract class _UserModel with Store{
  @observable
  int? id;

  @observable
  String name = "";

  @observable
  String email = "";

  @observable
  ObservableList<CartItemModel> cart = ObservableList.of([]);
}