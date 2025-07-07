import 'dart:math';

import 'package:ecommerce_app/src/features/authentication/data/auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_app/src/features/products/data/products_fake_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartService {
  CartService(
      {required AuthRepository authRepository,
      required LocalCartRepository localCartRepository,
      required RemoteCartRepository remoteCartRepository})
      : _authRepository = authRepository,
        _localCartRepository = localCartRepository,
        _remoteCartRepository = remoteCartRepository;

  final AuthRepository _authRepository;
  final LocalCartRepository _localCartRepository;
  final RemoteCartRepository _remoteCartRepository;

  /// fetch the cart from the local or remote repository
  /// depending on the user auth state
  Future<Cart> _fetchCart() {
    final user = _authRepository.currentUser;
    if (user != null) {
      return _remoteCartRepository.fetchCart(user.uid);
    } else {
      return _localCartRepository.fetchCart();
    }
  }

  /// save the cart to the local or remote repository
  /// depending on the user auth state
  Future<void> _setCart(Cart cart) async {
    final user = _authRepository.currentUser;
    if (user != null) {
      return _remoteCartRepository.setCart(user.uid, cart);
    } else {
      return _localCartRepository.setCart(cart);
    }
  }

  /// sets an item in the local or remote cart depending on the user auth state
  Future<void> setItem(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.setItem(item);
    await _setCart(updated);
  }

  /// adds an item in the local or remote cart depending on the user auth state
  Future<void> addItem(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.addItem(item);
    await _setCart(updated);
  }

  /// removes an item from the local or remote cart depending on the user auth state
  Future<void> removeItemById(ProductID id) async {
    final cart = await _fetchCart();
    final updated = cart.removeItemById(id);
    await _setCart(updated);
  }
}

final cartServiceProvider = Provider<CartService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final localCartRepository = ref.watch(localCartRepositoryProvider);
  final remoteCartRepository = ref.watch(remoteCartRepositoryProvider);

  return CartService(
      authRepository: authRepository, localCartRepository: localCartRepository, remoteCartRepository: remoteCartRepository);
});

final cartProvider = StreamProvider<Cart>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref.watch(remoteCartRepositoryProvider).watchCart(user.uid);
  } else {
    return ref.watch(localCartRepositoryProvider).watchCart();
  }
});

final cartItemsCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).maybeMap(
        data: (state) => state.value.items.length,
        orElse: () => 0,
      );
});

final cartTotalPriceProvider = Provider.autoDispose<double>((ref) {
  final cart = ref.watch(cartProvider).value ?? Cart();
  final productsList = ref.watch(productsStreamProvider).value ?? [];
  if (cart.items.isNotEmpty && productsList.isNotEmpty) {
    final total = cart.items.entries.fold(0.0, (sum, item) {
      final product = productsList.firstWhere((e) => e.id == item.key);
      return sum + product.price * item.value;
    });

    return total;
  } else {
    return 0.0;
  }
});

final itemAvailableQuantityProvider = Provider.autoDispose.family<int, Product>((ref, product) {
  final cart = ref.watch(cartProvider).value;
  if (cart != null) {
    final quantityInCart = cart.items[product.id] ?? 0;
    return max(0, product.availableQuantity - quantityInCart);
  } else {
    return product.availableQuantity;
  }
});
