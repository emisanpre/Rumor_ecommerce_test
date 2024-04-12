import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/network/dio_manager.dart';
import '../../../core/services/product/mock_product_service.dart';
import '../../../core/services/service_state.dart';
import '../../../core/widgets/product_grid.dart';
import '../viewModel/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel _homeViewModel = HomeViewModel(MockProductService(DioManager.instance.dio));

  @override
  void initState() {
    super.initState();
    _homeViewModel.fetchAllProductService();
  }
  
  @override
  Widget build(BuildContext context) {
    return _buildHomeView();
  }

  Observer _buildHomeView() {
    return Observer(
      builder: (_) {
        switch (_homeViewModel.serviceState) {
          case ServiceState.loading:
            return const Scaffold(
              body: Center(
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
              appBar: AppBar(),
              body: ProductGrid(products: _homeViewModel.products,),
            );
          case ServiceState.error:
            return const Scaffold(
              body: Center(
                child: Text("Something went wrong!"),
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}