import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rumor_ecommerce_test/core/managers/user/user_data_manager.dart';
import 'package:rumor_ecommerce_test/core/services/auth/i_auth_service.dart';
import 'package:rumor_ecommerce_test/core/services/product/i_product_service.dart';
import 'package:rumor_ecommerce_test/core/widgets/product_card.dart';
import 'package:rumor_ecommerce_test/models/product/product_model.dart';
import 'package:rumor_ecommerce_test/models/user/user_model.dart';
import 'package:rumor_ecommerce_test/views/auth/view/auth_view.dart';
import 'package:rumor_ecommerce_test/views/home/view/home_view.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([IAuthService, IProductService])
void main() {
  late IAuthService authService;
  late IProductService productService;

  setUp(() {
    authService = MockIAuthService();
    productService = MockIProductService();
  });

  group('AuthView Tests', () {
    testWidgets('Sign Up Process Test', (WidgetTester tester) async {
      //Arrange mock sign up
      when(authService.signUp('Test', 'test@test.com', 'password')).thenAnswer((_) async {
          return UserModel(id: '1', name: 'Test', email: 'test@test.com');
      });

      //Load AuthView
      await tester.pumpWidget(MaterialApp(home: AuthView(authService: authService,)));

      //Change to sign up view
      await tester.tap(find.text("Don't you have an account? Go to sign up."));
      await tester.pumpAndSettle();

      //Enter values in sign up form
      await tester.enterText(find.byKey(const ValueKey('signUpName')), 'Test');
      await tester.enterText(find.byKey(const ValueKey('signUpEmail')), 'test@test.com');
      await tester.enterText(find.byKey(const ValueKey('signUpPassword')), 'password');

      //Send sign up form
      await tester.tap(find.byKey(const ValueKey('signUpButton')));

      //Verify if sign up was called
      verify(authService.signUp('Test', 'test@test.com', 'password')).called(1);

      //Wait to refresh
      await tester.pumpAndSettle();

      //Verify if HomeView is loaded
      expect(find.byType(HomeView), findsOneWidget);
    });

    testWidgets('Sign In Process Test', (WidgetTester tester) async {
      //Arrange mock sign in
      when(authService.signIn('test@test.com', 'password')).thenAnswer((_) async {
          return UserModel(id: '1', name: 'Test', email: 'test@test.com');
      });

      //Load AuthView
      await tester.pumpWidget(MaterialApp(home: AuthView(authService: authService,)));

      //Enter values in sign in form
      await tester.enterText(find.byKey(const ValueKey('signInEmail')), 'test@test.com');
      await tester.enterText(find.byKey(const ValueKey('signInPassword')), 'password');

      //Send sign in form
      await tester.tap(find.byKey(const ValueKey('signInButton')));

      //Verify if sign in was called
      verify(authService.signIn('test@test.com', 'password')).called(1);

      //Wait to refresh
      await tester.pumpAndSettle();

      //Verify if HomeView is loaded
      expect(find.byType(HomeView), findsOneWidget);
    });
  });

  group('HomeView Tests', () { 
    testWidgets('Show Products Test', (WidgetTester tester) async {
      //Arrange mock sign up
      when(productService.fetchProducts()).thenAnswer((_) async {
        List<ProductModel> products = [
          const ProductModel(id: 1, title: 'Product 1', price: 9.99, description: 'Description product 1', category: 'Test'),
          const ProductModel(id: 2, title: 'Product 2', price: 19.99, description: 'Description product 2', category: 'Test'),
          const ProductModel(id: 3, title: 'Product 2', price: 4.99, description: 'Description product 3', category: 'Test'),
        ];
        return products;
      });

      UserDataManager.user = UserModel(id: '1', name: 'Test', email: 'test@test.com');

      //Load HomeView
      await tester.pumpWidget(MaterialApp(home: HomeView(authService: authService, productService: productService)));

      //Wait to refresh
      await tester.pumpAndSettle();

      //Verify if the 3 products were loaded
      expect(find.byType(ProductCard), findsNWidgets(3));
    });
  });

}
