import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class RemoteCartRepository {
  Future<Cart> fetchCart(String uid);

  Stream<Cart> watchCart(String uid);

  Future<void> setCart(String uid, Cart cart);
}

final remoteCartRepositoryProvider = Provider<RemoteCartRepository>((ref) {
// * Override this in the main method
  throw UnimplementedError();
});
