import 'dart:async';

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsFakeRepository {
  ProductsFakeRepository({this.addDelay = true});
  final bool addDelay;

  /// Preload with the default list of products when the app starts
  final _products = InMemoryStore<List<Product>>(List.from(kTestProducts));
  List<Product> getProducts() {
    return _products.value;
  }

  Product? getProductById(String id) {
    return _getProduct(_products.value, id);
  }

  Future<List<Product>> fetchProductsList() async {
    await delay(addDelay);
    return Future.value(_products.value);
  }

  Stream<List<Product>> watchProductsList() {
    return _products.stream;
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList().map((products) => _getProduct(products, id));
  }

  /// Update product or add a new one
  Future<void> setProduct(Product product) async {
    await delay(addDelay);
    final products = _products.value;
    final index = products.indexWhere((p) => p.id == product.id);
    if (index == -1) {
      // if not found, add as a new product
      products.add(product);
    } else {
      // else, overwrite previous product
      products[index] = product;
    }
    _products.value = products;
  }

  static Product? _getProduct(List<Product> products, String id) {
    return products.where((element) => element.id == id).firstOrNull;
  }
}

final productsRepositoryProvider = Provider<ProductsFakeRepository>((ref) {
  return ProductsFakeRepository();
});

final productsListFutureProvider = FutureProvider<List<Product>>((ref) {
  final repo = ref.watch(productsRepositoryProvider);
  return repo.fetchProductsList();
});

final productsStreamProvider = StreamProvider.autoDispose<List<Product>>((ref) {
  final repo = ref.watch(productsRepositoryProvider);
  return repo.watchProductsList();
});

// autoDispose modifier to dispose provider when no longer used by any widget
// family modifier to pass values as argument to a Provider
final productProvider = StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  // Setting up a simples caching from provider
  //final link = ref.keepAlive();
  // Disposing provider after 10 seconds
  //Timer(const Duration(seconds: 10), () => link.close());
  final repo = ref.watch(productsRepositoryProvider);
  return repo.watchProduct(id);
});
