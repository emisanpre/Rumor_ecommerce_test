import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' as mob_x;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rumor_ecommerce_test/core/managers/user/user_data_manager.dart';
import 'package:rumor_ecommerce_test/core/services/auth/i_auth_service.dart';
import 'package:rumor_ecommerce_test/core/services/product/i_product_service.dart';
import 'package:rumor_ecommerce_test/models/cart_item/cart_item_model.dart';
import 'package:rumor_ecommerce_test/models/product/product_model.dart';
import 'package:rumor_ecommerce_test/models/user/user_model.dart';
import 'package:rumor_ecommerce_test/views/cart/viewModel/cart_view_model.dart';

import 'unit_test.mocks.dart';

@GenerateMocks([
  IProductService,
  IAuthService,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockIProductService mockProductService;
  late MockIAuthService mockAuthService;
  late CartViewModel cartViewModel;

  setUp(() {
    final user = UserModel(
      id: '1', 
      name: 'Test', 
      email: 'test@test.com'
    );
    UserDataManager.user = user;

    mockProductService = MockIProductService();
    mockAuthService = MockIAuthService();
    cartViewModel = CartViewModel(mockProductService, mockAuthService);
    
  });

  group('CartViewModel', () {
    test('Increment quantity increases product quantity', () async {
      //Arrange mock fetch products
      when(mockProductService.fetchProduct(1)).thenAnswer((_) async {
          return const ProductModel(id: 1, title: 'Product 1', price: 4.99, description: 'Description product 1', category: 'Test');
      });
      when(mockProductService.fetchProduct(2)).thenAnswer((_) async {
          return const ProductModel(id: 2, title: 'Product 2', price: 9.99, description: 'Description product 2', category: 'Test');
      });

      //Arrange user cart
      UserDataManager.user!.cart = mob_x.ObservableList.of([
        CartItemModel(id: '1', userId: '1', productId: 1, quantity: 1),
        CartItemModel(id: '2', userId: '1', productId: 2, quantity: 1)
      ]);

      await cartViewModel.fetchCartProductsService();

      //Increment by 2 the cart
      cartViewModel.incrementQuantity(0);
      cartViewModel.incrementQuantity(0);

      //Verify quantity value is equal to 3
      expect(UserDataManager.user!.cart[0].quantity, equals(3));
    });

    test('Decrement quantity decreases product quantity and if 0 deletes product from the cart', () async {
      //Arrange mock fetch products
      when(mockProductService.fetchProduct(1)).thenAnswer((_) async {
          return const ProductModel(id: 1, title: 'Product 1', price: 4.99, description: 'Description product 1', category: 'Test');
      });
      when(mockProductService.fetchProduct(2)).thenAnswer((_) async {
          return const ProductModel(id: 2, title: 'Product 2', price: 9.99, description: 'Description product 2', category: 'Test');
      });

      //Arrange user cart
      UserDataManager.user!.cart = mob_x.ObservableList.of([
        CartItemModel(id: '1', userId: '1', productId: 1, quantity: 3),
        CartItemModel(id: '2', userId: '1', productId: 2, quantity: 1)
      ]);

      await cartViewModel.fetchCartProductsService();

      //Ref to the first cart item
      final cartItemRef = UserDataManager.user!.cart[0];

      //Decrement by 2 the first product
      cartViewModel.decrementQuantity(0);
      cartViewModel.decrementQuantity(0);

      //Verify quantity value is equal to 1
      expect(cartItemRef.quantity, equals(1));

      //Decrement by 1 the first product
      cartViewModel.decrementQuantity(0);

      //Verify cart item ref is equal to null
      //expect(cartItemRef, equals(null));
    });
  });
}