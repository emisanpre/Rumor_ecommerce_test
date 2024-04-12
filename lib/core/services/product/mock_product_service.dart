import 'dart:io';

import 'i_product_service.dart';
import '../../../models/product/product_model.dart';

class MockProductService extends IProductService {
  MockProductService(super.dio);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await dio.get('products');
      if (response.statusCode == HttpStatus.ok) {
        List<ProductModel> products = (response.data as List)
            .map((json) => ProductModel.fromJson(json))
            .toList();
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
