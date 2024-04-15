import 'package:dio/dio.dart';

import '../../../models/product/product_model.dart';

/// Interface for product service.
///
/// This interface defines methods for fetching product information from an external API.
abstract class IProductService {
  /// Dio instance used for HTTP requests.
  final Dio dio;

  /// Creates an instance of [IProductService].
  ///
  /// [dio]: Dio instance for HTTP requests.
  IProductService(this.dio);

  /// Fetches a list of all products.
  ///
  /// Returns a list of [ProductModel] representing the products.
  Future<List<ProductModel>> fetchProducts();

  /// Fetches a specific product by its ID.
  ///
  /// [id]: ID of the product to fetch.
  ///
  /// Returns a [ProductModel] representing the fetched product.
  Future<ProductModel> fetchProduct(int id);
}
