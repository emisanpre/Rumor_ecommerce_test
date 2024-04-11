import 'package:mobx/mobx.dart';

import '../../../core/services/product/i_product_service.dart';
import '../../../core/services/service_state.dart';
import '../../../models/product/product_model.dart';

part 'home_view_model.g.dart';

class HomeViewModel = HomeViewModelBase with _$HomeViewModel;

abstract class HomeViewModelBase with Store {
  HomeViewModelBase(this.productService);

  final IProductService productService;

  @observable
  List<ProductModel> products = [];

  @observable
  ServiceState serviceState = ServiceState.normal;

  @action
  Future<void> fetchAllProductService() async {
    serviceState = ServiceState.loading;
    try {
      products = await productService.fetchProducts();

      serviceState = ServiceState.success;
    } catch (e) {
      print(e);
      serviceState = ServiceState.error;
    }
  }
}