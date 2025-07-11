import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/fake_local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/fake_remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/products/data/products_fake_repository.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/more_menu_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/authentication/auth_robot.dart';
import 'features/cart/cart_robot.dart';
import 'features/products/products_robot.dart';

class Robot {
  Robot(this.tester)
      : authRobot = AuthRobot(tester),
        products = ProductsRobot(tester),
        cart = CartRobot(tester);
  final WidgetTester tester;
  final AuthRobot authRobot;
  final ProductsRobot products;
  final CartRobot cart;

  Future<void> pumpMyApp() async {
    final authRepository = FakeAuthRepository(addDelay: false);
    final productsRepository = ProductsFakeRepository(addDelay: false);
    final localCartRepository = FakeLocalCartRepository(addDelay: false);
    final remoteCartRepository = FakeRemoteCartRepository(addDelay: false);

    final container = ProviderContainer(
      overrides: [
        productsRepositoryProvider.overrideWithValue(productsRepository),
        authRepositoryProvider.overrideWithValue(authRepository),
        localCartRepositoryProvider.overrideWithValue(localCartRepository),
        remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
      ],
    );
    // * Initialize CartSyncService to start the listener
    container.read(cartSyncServiceProvider);
    // * Entry point of the app
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ));
    // Pump until there's no more frames to render
    await tester.pumpAndSettle();
  }

  Future<void> openPopupMenu() async {
    final finder = find.byType(MoreMenuButton);
    final matcher = finder.evaluate();
    // if an item is found, it means that we're running on a small window
    // and can tap to reveal the menu
    if (matcher.isNotEmpty) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
    // else no-op, as the items are already visible
  }
}
