import 'dart:async';

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsFakeRepository {
  final List<Product> _products = kTestProducts;

  List<Product> getProducts() {
    return _products;
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>> fetchProductsList() async {
    await Future.delayed(Duration(seconds: 2));
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() async* {
    await Future.delayed(Duration(seconds: 2));
    yield _products;
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList()
        .map((products) => products.firstWhere((product) => product.id == id));
  }
}

final productsRepositoryProvider = Provider<ProductsFakeRepository>((ref) {
  return ProductsFakeRepository();
});

final productsListFutureProvider = FutureProvider<List<Product>>((ref) {
  final repo = ref.watch(productsRepositoryProvider);
  return repo.fetchProductsList();
});

final productsSreamProvider = StreamProvider<List<Product>>((ref) {
  final repo = ref.watch(productsRepositoryProvider);
  return repo.watchProductsList();
});

// autoDispose modifier to dispose provider when no longer used by any widget
// family modifier to pass values as argument to a Provider
final productProvider =
    StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  // Setting up a simples caching from provider
  //final link = ref.keepAlive();
  // Disposing provider after 10 seconds
  //Timer(const Duration(seconds: 10), () => link.close());
  final repo = ref.watch(productsRepositoryProvider);
  return repo.watchProduct(id);
});
