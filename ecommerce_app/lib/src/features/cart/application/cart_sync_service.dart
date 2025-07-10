import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
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
    final localCartRepository = ref.watch(localCartRepositoryProvider);
    final localCart = await localCartRepository.fetchCart();
    if (localCart.toItemsList().isNotEmpty) {
      // Get the remote cart data
      final remoteCartRepository = ref.watch(remoteCartRepositoryProvider);
      final remoteCart = await remoteCartRepository.fetchCart(uid);
      // Move local items to the remote cart
      final localItemsToAdd = localCart.toItemsList();
      final updatedCart = remoteCart.addItems(localItemsToAdd);
      // Write the updated local cart to the remote repository
      await remoteCartRepository.setCart(uid, updatedCart);
      // Remove all itens from the local cart
      await localCartRepository.setCart(const Cart());
    }
  }
}

final cartSyncServiceProvider = Provider<CartSyncService>((ref) {
  return CartSyncService(ref);
});
