import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/products/data/products_fake_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('cartTotalProvider', () {
    ProviderContainer makeProviderContainer({
      required Stream<Cart> cart,
      required Stream<List<Product>> productsList,
    }) {
      final container = ProviderContainer(overrides: [
        cartProvider.overrideWith((ref) => cart),
        productsStreamProvider.overrideWith((ref) => productsList),
      ]);
      addTearDown(container.dispose);
      return container;
    }

    test('loading cart', () async {
      final container = makeProviderContainer(
        cart: const Stream.empty(),
        productsList: Stream.value(kTestProducts),
      );
      await container.read(productsStreamProvider.future);
      final total = container.read(cartTotalPriceProvider);
      expect(total, 0);
    });

    test('Empty cart', () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart()),
        productsList: Stream.value(kTestProducts),
      );
      await container.read(cartProvider.future);
      await container.read(productsStreamProvider.future);
      final total = container.read(cartTotalPriceProvider);
      expect(total, 0);
    });

    test('one product with quantity = 1', () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart({'1': 1})),
        productsList: Stream.value(kTestProducts),
      );
      await container.read(cartProvider.future);
      await container.read(productsStreamProvider.future);
      final total = container.read(cartTotalPriceProvider);
      expect(total, 15);
    });

    test('one product with quantity = 5', () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart({'1': 5})),
        productsList: Stream.value(kTestProducts),
      );
      await container.read(cartProvider.future);
      await container.read(productsStreamProvider.future);
      final total = container.read(cartTotalPriceProvider);
      expect(total, 75); // 15 * 5 = 75
    });

    test('product not found', () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart({'100': 1})),
        productsList: Stream.value(kTestProducts),
      );
      await container.read(cartProvider.future);
      await container.read(productsStreamProvider.future);
      expect(() => container.read(cartTotalPriceProvider), throwsStateError);
    });
  });
}
