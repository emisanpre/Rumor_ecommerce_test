import 'package:mobx/mobx.dart';

import '../../../core/services/auth/i_auth_service.dart';
import '../../../core/services/product/i_product_service.dart';
import '../../../core/services/service_state.dart';
import '../../../core/utils/secure_storage_helper.dart';
import '../../../models/product/product_model.dart';

part 'home_view_model.g.dart';

class HomeViewModel = HomeViewModelBase with _$HomeViewModel;

abstract class HomeViewModelBase with Store {
  HomeViewModelBase(this.productService, this.authService){
    fetchAllProductService();
  }

  final IProductService productService;
  final IAuthService authService;

  @observable
  List<ProductModel> products = [];

  @observable
  List<ProductModel> filteredProducts = [];

  @observable
  String searchText = '';

  @observable
  ServiceState serviceState = ServiceState.normal;

  @observable
  String errorMessage = "An error has ocurred";

  @action
  Future<void> fetchAllProductService() async {
    serviceState = ServiceState.loading;
    try {
      products = await productService.fetchProducts();
      filteredProducts = products;
      serviceState = ServiceState.success;
    } on Exception catch (e) {
      errorMessage = e.toString().replaceAll('Exception:', '');
      serviceState = ServiceState.error;
    } catch (e) {
      errorMessage = e.toString();
      serviceState = ServiceState.error;
    }
  }

  @action
  Future<void> filterProductsService() async{
    try {
      filteredProducts = searchText.isNotEmpty 
        ? products
            .where(
              (product) => product.title.toLowerCase().contains(searchText.toLowerCase())
            )
            .toList()
        : products;

      if(filteredProducts.isEmpty){
        filteredProducts = products;
      }
        
    }on Exception catch (e) {
      errorMessage = e.toString().replaceAll('Exception:', '');
      serviceState = ServiceState.error;
    } catch (e) {
      errorMessage = e.toString();
      serviceState = ServiceState.error;
    }
  }

  @action
  Future<void> logOutService() async {
    serviceState = ServiceState.loading;
    try {
      await authService.logOut();
      SecureStorageHelper.deleteData(key: 'authUser');

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