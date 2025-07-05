import 'package:ecommerce_app/src/features/authentication/data/auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/presentation/add_to_cart/add_to_cart_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const Cart());
  });

  late AuthRepository authRepository;
  late LocalCartRepository localCartRepository;
  late RemoteCartRepository remoteCartRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    localCartRepository = MockLocalCartRepository();
    remoteCartRepository = MockRemoteCartRepository();
  });

  CartService makeCartService() {
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      localCartRepositoryProvider.overrideWithValue(localCartRepository),
      remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
    ]);
    addTearDown(container.dispose);
    return container.read(cartServiceProvider);
  }

  group('Update quantity', () {
    test('Initial value should be 1', () {
      final controller = AddToCartController(cartService: makeCartService());
      expect(controller.debugState, AsyncData(1));
    });

    test('Updating quantity in 3 should return 3', () {
      final controller = AddToCartController(cartService: makeCartService());
      controller.updateQuantity(3);
      expect(controller.debugState, AsyncData(3));
    });
  });

  group("addToCart", () {
    test('''
      Given a product with 3 units
      When add to cart succeed
      Then value is AsyncData
      ''', () async {
      // setup
      final item = Item(productId: '123', quantity: 3);
      when(() => authRepository.currentUser).thenReturn(null);
      when(() => localCartRepository.fetchCart()).thenAnswer((_) => Future.value(Cart()));
      when(() => localCartRepository.setCart(any())).thenAnswer((_) => Future.value(null));
      final cartService = makeCartService();
      final controller = AddToCartController(cartService: cartService);
      // run
      controller.updateQuantity(item.quantity);
      await controller.addToCart(item.productId);
      // verify
      verify(() => localCartRepository.fetchCart()).called(1);
      verify(() => localCartRepository.setCart(any())).called(1);
      expect(controller.debugState, AsyncData(1));
    });
  });
}
