import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/network/dio_manager.dart';
import '../../../core/services/auth/mock_auth_service.dart';
import '../../../core/services/product/mock_product_service.dart';
import '../../../core/services/service_state.dart';
import '../viewModel/cart_view_model.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartViewModel _cartViewModel = CartViewModel(
    MockProductService(DioManager.instance.dio), 
    MockAuthService(DioManager.instance.dio)
  );

  @override
  Widget build(BuildContext context) {
    return _buildCartView(context);
  }

  Observer _buildCartView(BuildContext context){
    return Observer(
      builder: (_){
        switch (_cartViewModel.serviceState) {
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
          case ServiceState.success:
            return Scaffold(
              appBar: AppBar(
                title: const Text('Shopping cart'),
              ),
              body: PopScope(
                onPopInvoked: (didPop) {
                  _cartViewModel.updateUserService();
                },
                child: _cartViewModel.products.isNotEmpty 
                  ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(5),
                          itemCount: _cartViewModel.products.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                title: Text(_cartViewModel.products[index].title),
                                subtitle: Text('Quantity: ${_cartViewModel.userCart![index].quantity}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        _cartViewModel.decrementQuantity(index);
                                        setState(() {});
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        _cartViewModel.incrementQuantity(index);
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                  : Center(
                    child: Text(
                      "Cart is empty.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      ),
                    )
                  ),
              ),
            );
          case ServiceState.error:
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text(_cartViewModel.errorMessage),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        _cartViewModel.serviceState = ServiceState.normal;
                        _cartViewModel.fetchCartProductsService();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                );
              },
            );
          return const Scaffold();
          default:
            return Scaffold(
              appBar: AppBar(),
            );
        }
      }
    );
  }
}