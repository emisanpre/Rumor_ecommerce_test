import 'package:dio/dio.dart';

import '../../../models/product/product_model.dart';

abstract class IProductService {
  final Dio dio;
  IProductService(this.dio);

  Future<List<ProductModel>> fetchProducts();
}
