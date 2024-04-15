import 'package:mobx/mobx.dart';

import '../../../core/services/auth/i_auth_service.dart';
import '../../../core/services/product/i_product_service.dart';
import '../../../core/services/service_state.dart';
import '../../../core/utils/secure_storage_helper.dart';
import '../../../models/product/product_model.dart';

part 'home_view_model.g.dart';

/// ViewModel for managing the home screen.
///
/// This class handles operations related to displaying products on the home screen,
/// including fetching all products, filtering products based on search text,
/// and logging out the user.
class HomeViewModel = HomeViewModelBase with _$HomeViewModel;

abstract class HomeViewModelBase with Store {
  /// Creates an instance of [HomeViewModel].
  ///
  /// [productService]: Product service.
  /// [authService]: Authentication service.
  HomeViewModelBase(this.productService, this.authService){
    fetchAllProductService();
  }

  /// Product service used to fetch product details.
  final IProductService productService;

  /// Authentication service used for user authentication.
  final IAuthService authService;

  /// List of all products available.
  @observable
  List<ProductModel> products = [];

  /// List of products filtered based on search text.
  @observable
  List<ProductModel> filteredProducts = [];

  /// Text used for searching products.
  @observable
  String searchText = '';

  /// State of the service for fetching products.
  @observable
  ServiceState serviceState = ServiceState.normal;

  /// Error message displayed in case an error occurs during home screen operations.
  @observable
  String errorMessage = "An error has ocurred";

  /// Fetches all products available.
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

  /// Filters products based on search text.
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

  /// Logs out the user.
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