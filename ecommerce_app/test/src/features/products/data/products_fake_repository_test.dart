import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/products_fake_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ProductsFakeRepository makeProductsRepository() =>
      ProductsFakeRepository(addDelay: false);

  group('FakeProductsRepository', () {
    test(
      'getProducts returns global list',
      () {
        final productsRepository = makeProductsRepository();
        expect(productsRepository.getProducts(), kTestProducts);
      },
      tags: ['unit'],
    );

    test(
      "getProductById('1') should return first product",
      () {
        final productsRepository = makeProductsRepository();
        expect(productsRepository.getProductById('1'), kTestProducts.first);
      },
      tags: ['unit'],
    );

    test(
      "getProductById('100') should return null",
      () {
        final productsRepository = makeProductsRepository();
        expect(productsRepository.getProductById('100'), null);
      },
      tags: ['unit'],
    );
  });

  test(
    "fetchProductList should return kTestProducts",
    () async {
      final productsRepository = makeProductsRepository();
      expect(await productsRepository.fetchProductsList(), kTestProducts);
    },
    tags: ['unit'],
  );

  test(
    "watchProductsList should emit kTestProducts",
    () {
      final productsRepository = makeProductsRepository();
      expect(productsRepository.watchProductsList(), emits(kTestProducts));
    },
    tags: ['unit'],
  );

  test(
    "watchProduct('1') should emit first product",
    () {
      final productsRepository = makeProductsRepository();
      expect(productsRepository.watchProduct('1'), emits(kTestProducts.first));
    },
    tags: ['unit'],
  );

  test(
    "watchProduct('100') should emit null",
    () {
      final productsRepository = makeProductsRepository();
      expect(productsRepository.watchProduct('100'), emits(null));
    },
    tags: ['unit'],
  );
}
