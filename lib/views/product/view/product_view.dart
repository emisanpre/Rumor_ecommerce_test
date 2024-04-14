import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/network/dio_manager.dart';
import '../../../core/services/auth/mock_auth_service.dart';
import '../../../core/services/service_state.dart';
import '../../../core/widgets/rating_view.dart';
import '../../../models/product/product_model.dart';
import '../viewModel/product_view_model.dart';


class ProductView extends StatelessWidget {
  ProductView({super.key, required this.product});

  final ProductModel product;
  late final ProductViewModel _productViewModel = ProductViewModel( 
    MockAuthService(DioManager.instance.dio),
    product
  );
  
  @override
  Widget build(BuildContext context) {
    return _buildProductView(context);
  }

  Observer _buildProductView(BuildContext context){
    return Observer(
      builder: (_){
        switch (_productViewModel.serviceState) {
          case ServiceState.loading:
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 25,
                    ),
                    Text("Loading..."),
                  ],
                ),
              ),
            );
          case ServiceState.success || ServiceState.normal:
            return Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (product.image != null)
                      Image.network(
                        product.image!,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Category: ${product.category.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          RatingView(
                            value: product.ratingRate ?? 0,
                            reviewsCount: product.ratingCount ?? 0
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Price: \$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showQuantityDialog(context);
                            },
                            child: const Text('Add to cart'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          case ServiceState.error:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: Text(_productViewModel.errorMessage),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: const Text('Ok'),
                      ),
                    ],
                  );
                },
              );
            });
            return const Scaffold();
          default:
            return const SizedBox.shrink();
        }
      }
    );
  }
  
  void _showQuantityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Observer(
          builder: (_){
            return AlertDialog(
              title: const Text('Select quantity'),
              content: Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (_productViewModel.quantity > 1) {
                        _productViewModel.quantity--;
                      }
                    },
                  ),
                  Text(_productViewModel.quantity.toString()),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      _productViewModel.quantity++;
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _productViewModel.updateUserCartService();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('Add'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          }
        );
      },
    );
  }
}
