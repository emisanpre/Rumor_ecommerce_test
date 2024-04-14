import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/managers/user/user_data_manager.dart';
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
              appBar: AppBar(
                title: const Text('Shopping cart'),
              ),
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
                        flex: 5,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(5),
                          itemCount: _cartViewModel.products.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                title: Text(_cartViewModel.products[index].title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10,),
                                    Text('Quantity: ${UserDataManager.user!.cart[index].quantity}'),
                                    Text('Price: \$${(_cartViewModel.products[index].price * UserDataManager.user!.cart[index].quantity).toStringAsFixed(2)}'),
                                  ],
                                ),
                                leading: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _cartViewModel.deleteItem(index);
                                    setState(() {});
                                  },
                                ),
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
                      Expanded(
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                const Text(
                                  "Total: ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "\$${_cartViewModel.calulateTotal().toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () async {
                                    await _cartViewModel.checkOut();
                                    if(context.mounted) Navigator.pop(context);
                                  }, 
                                  child: const Text(
                                    "Check out",
                                    style: TextStyle(
                                      fontSize: 20
                                    ),
                                  )
                                ),
                              ],
                            ),
                          ),
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
            WidgetsBinding.instance.addPostFrameCallback((_) {
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
            return Scaffold(
              appBar: AppBar(),
            );
        }
      }
    );
  }
}