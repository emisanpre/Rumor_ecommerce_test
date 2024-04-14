import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/network/dio_manager.dart';
import '../../../core/services/auth/mock_auth_service.dart';
import '../../../core/services/product/mock_product_service.dart';
import '../../../core/services/service_state.dart';
import '../../../core/widgets/product_grid.dart';
import '../../auth/view/auth_view.dart';
import '../../cart/view/cart_view.dart';
import '../viewModel/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel _homeViewModel = HomeViewModel(
    MockProductService(DioManager.instance.dio),
    MockAuthService(DioManager.instance.dio)
  );

  @override
  void initState() {
    super.initState();
    _homeViewModel.fetchAllProductService();
  }
  
  @override
  Widget build(BuildContext context) {
    return _buildHomeView();
  }

  Observer _buildHomeView(){
    return Observer(
      builder: (_){
        switch (_homeViewModel.serviceState) {
          case ServiceState.loading:
            return Scaffold(
              appBar: AppBar(
                title: Text("Welcome ${_homeViewModel.user.name}!"),
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
              extendBody: true,
              appBar: AppBar(
                title: Text("Welcome ${_homeViewModel.user.name}!"),
              ),
              body: ProductGrid(
                products: _homeViewModel.products,
                onRefresh: () async {
                  await _homeViewModel.fetchAllProductService();
                },
              ),
              floatingActionButton: Stack(
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartView()),
                      );
                    },
                    shape: const CircleBorder(),
                    child: const Icon(Icons.shopping_cart),
                  ),
                  if (_homeViewModel.user.cart != null && _homeViewModel.user.cart!.isNotEmpty)
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          _homeViewModel.user.cart!.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: BottomAppBar(
                notchMargin: 10,
                shape: const CircularNotchedRectangle(),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Spacer(),
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.exit_to_app),
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Alert.'),
                              content: const Text('Do you want to log out?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await _homeViewModel.logOutService();
                                    if(context.mounted){
                                      Navigator.popUntil(context, (route) => route.isFirst);
                                      
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const AuthView()),
                                      );
                                    }
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      },
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
                    content: Text(_homeViewModel.errorMessage),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          _homeViewModel.serviceState = ServiceState.normal;
                          _homeViewModel.fetchAllProductService();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Retry'),
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
}