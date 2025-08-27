import 'dart:math';

import 'package:ecommerce_app/src/exceptions/error_logger.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_app/src/features/products/data/products_fake_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartSyncService {
  CartSyncService(this.ref) {
    _init();
  }
  final Ref ref;

  void _init() {
    ref.listen<AsyncValue<AppUser?>>(authStateChangesProvider, (previous, next) {
      final previousUser = previous?.value;
      final user = next.value;
      if (previousUser == null && user != null) {
        _moveItemsToRemoteCart(user.uid);
      }
    });
  }

  void _moveItemsToRemoteCart(String uid) async {
    try {
      final localCartRepository = ref.read(localCartRepositoryProvider);
      final localCart = await localCartRepository.fetchCart();
      if (localCart.toItemsList().isNotEmpty) {
        // Get the remote cart data
        final remoteCartRepository = ref.read(remoteCartRepositoryProvider);
        final remoteCart = await remoteCartRepository.fetchCart(uid);
        // Move local items to the remote cart
        final localItemsToAdd = await _getLocalItensToAdd(localCart, remoteCart);
        final updatedCart = remoteCart.addItems(localItemsToAdd);
        // Write the updated local cart to the remote repository
        await remoteCartRepository.setCart(uid, updatedCart);
        // Remove all itens from the local cart
        await localCartRepository.setCart(const Cart());
      }
    } catch (e, st) {
      ref.read(errorLoggerProvider).logError(e, st);
    }
  }

  Future<List<Item>> _getLocalItensToAdd(Cart localCart, Cart remoteCart) async {
    final productsRepository = ref.read(productsRepositoryProvider);
    final products = await productsRepository.fetchProductsList();

    List<Item> localItemsToAdd = [];
    for (final item in localCart.items.entries) {
      final productId = item.key;
      final localItemQuantity = item.value;
      // get the quantity for the corresponding item in the remote cart
      final remoteItemQuantity = remoteCart.items[productId] ?? 0;

      final product = products.firstWhere((e) => e.id == productId);
      // Cap the quantity of each item to the available quantity
      final capQuantity = min(
        localItemQuantity,
        product.availableQuantity - remoteItemQuantity,
      );
      // if the capped quantity is > 0, add to the list of items to add
      if (capQuantity > 0) {
        localItemsToAdd.add(Item(productId: productId, quantity: capQuantity));
      }
    }

    return localItemsToAdd;
  }
}

final cartSyncServiceProvider = Provider<CartSyncService>((ref) {
  return CartSyncService(ref);
});
