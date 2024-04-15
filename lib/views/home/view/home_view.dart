import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/managers/user/user_data_manager.dart';
import '../../../core/network/dio_manager.dart';
import '../../../core/services/auth/auth_service.dart';
import '../../../core/services/auth/i_auth_service.dart';
import '../../../core/services/product/i_product_service.dart';
import '../../../core/services/product/product_service.dart';
import '../../../core/services/service_state.dart';
import '../../../core/widgets/product_grid.dart';
import '../../auth/view/auth_view.dart';
import '../../cart/view/cart_view.dart';
import '../viewModel/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, this.productService, this.authService});

  final IProductService? productService;
  final IAuthService? authService;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel _homeViewModel;

  Timer? _debounce;

  @override
  void initState() {
    if(widget.authService == null){
      _homeViewModel = HomeViewModel(
        ProductService(DioManager.instance.dio),
        AuthService(DioManager.instance.dio)
      );
    }
    else{
      _homeViewModel = HomeViewModel(widget.productService!, widget.authService!);
    } 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildHomeView(context);
  }

  Observer _buildHomeView(BuildContext context){
    return Observer(
      builder: (_){
        switch (_homeViewModel.serviceState) {
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
              extendBody: true,
              appBar: AppBar(
                title: TextField(
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white
                  ),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white54
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    if (_debounce?.isActive ?? false) _debounce?.cancel();

                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      _homeViewModel.searchText = value;
                      _homeViewModel.filterProductsService();
                    });
                  },
                ),
              ),
              body: ProductGrid(
                products: _homeViewModel.filteredProducts,
                onRefresh: () async {
                  await _homeViewModel.fetchAllProductService();
                  _homeViewModel.searchText = '';
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
                  if (UserDataManager.user!.cart.isNotEmpty)
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          UserDataManager.user!.cart.length.toString(),
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
                    SizedBox(
                      width: 150,
                      child: Text(
                        "Welcome ${UserDataManager.user!.name.split(' ').first}!",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
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