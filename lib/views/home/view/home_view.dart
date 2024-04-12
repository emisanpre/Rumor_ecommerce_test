import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/network/dio_manager.dart';
import '../../../core/services/auth/mock_auth_service.dart';
import '../../../core/services/product/mock_product_service.dart';
import '../../../core/services/service_state.dart';
import '../../../core/widgets/product_grid.dart';
import '../../auth/view/auth_view.dart';
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

  Observer _buildHomeView() {
    return Observer(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Welcome ${_homeViewModel.user.name}!"),
            actions: [
              IconButton(
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
          body: _buildHomeViewStates()
        );
      },
    );
  }

  Widget _buildHomeViewStates(){
    switch (_homeViewModel.serviceState) {
      case ServiceState.loading:
        return const Center(
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
        );
      case ServiceState.success:
        return ProductGrid(
          products: _homeViewModel.products,
          onRefresh: () async {
            await _homeViewModel.fetchAllProductService();
          },
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
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }
}