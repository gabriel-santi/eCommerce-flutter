import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/products/data/products_fake_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  // mock - auth / products / local cart / remote cart
  late MockAuthRepository authRepository;
  late MockProductsRepository productsRepository;
  late MockLocalCartRepository localCartRepository;
  late MockRemoteCartRepository remoteCartRepository;

  // setup mocking
  setUp(() {
    authRepository = MockAuthRepository();
    productsRepository = MockProductsRepository();
    localCartRepository = MockLocalCartRepository();
    remoteCartRepository = MockRemoteCartRepository();
  });

  // container constructor
  CartSyncService makeCartSyncService() {
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      productsRepositoryProvider.overrideWithValue(productsRepository),
      localCartRepositoryProvider.overrideWithValue(localCartRepository),
      remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
    ]);
    addTearDown(container.dispose);
    return container.read(cartSyncServiceProvider);
  }

  group('CartSyncService', () {
    // helper method
    Future<void> runCartSyncTest({
      required Map<ProductID, int> localCartItems,
      required Map<ProductID, int> remoteCartItems,
      required Map<ProductID, int> expectedRemoteCartItems,
    }) async {
      final uid = '123';
      when(() => authRepository.authStateChanges()).thenAnswer((_) => Stream.value(AppUser(uid: uid, email: "test@test.com")));
      when(() => productsRepository.fetchProductsList()).thenAnswer((_) => Future.value(kTestProducts));
      when(() => localCartRepository.fetchCart()).thenAnswer((_) => Future.value(Cart(localCartItems)));
      when(() => remoteCartRepository.fetchCart(uid)).thenAnswer((_) => Future.value(Cart(remoteCartItems)));
      when(() => remoteCartRepository.setCart(uid, Cart(expectedRemoteCartItems))).thenAnswer((_) => Future.value());
      when(() => localCartRepository.setCart(const Cart())).thenAnswer((_) => Future.value());
      // create cart sync service (return value not needed)
      makeCartSyncService();
      // wait for all the stubbed methods to return a value
      await Future.delayed(Duration());

      verify(() => remoteCartRepository.setCart(uid, Cart(expectedRemoteCartItems))).called(1);
      verify(() => localCartRepository.setCart(const Cart())).called(1);
    }

    // Single product tests
    test('local quantity <= available quantity', () async {
      await runCartSyncTest(
        localCartItems: {'1': 1},
        remoteCartItems: {},
        expectedRemoteCartItems: {'1': 1},
      );
    });

    test('local quantity > available quantity, should add only the available quantity', () async {
      await runCartSyncTest(
        localCartItems: {'1': 12},
        remoteCartItems: {},
        expectedRemoteCartItems: {'1': 5},
      );
    });

    test('local + remote quantity <= available quantity, should add', () async {
      await runCartSyncTest(
        localCartItems: {'1': 1},
        remoteCartItems: {'1': 3},
        expectedRemoteCartItems: {'1': 4},
      );
    });

    test('local + remote quantity > available quantity, should add only the available quantity', () async {
      await runCartSyncTest(
        localCartItems: {'1': 4},
        remoteCartItems: {'1': 3},
        expectedRemoteCartItems: {'1': 5},
      );
    });

    // Multiple products tests
    test('local + remote quantity <= available quantity', () async {
      await runCartSyncTest(
        localCartItems: {'1': 2, '2': 3},
        remoteCartItems: {'1': 1, '2': 1},
        expectedRemoteCartItems: {'1': 3, '2': 4},
      );
    });

    test('local + remote quantity > available quantity', () async {
      await runCartSyncTest(
        localCartItems: {'1': 4, '2': 3},
        remoteCartItems: {'1': 2, '2': 4},
        expectedRemoteCartItems: {'1': 5, '2': 5},
      );
    });
  });
}
