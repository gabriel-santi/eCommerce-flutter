import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/orders/domain/order.dart';
import 'package:ecommerce_app/src/features/products/data/products_fake_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A fake checkout service that doesn't process real payments.
class FakeCheckoutService {
  FakeCheckoutService(this.ref);
  final Ref ref;

  /// Temporary client-side logic for placing an order.
  /// Part of this logic should run on the server, so that we can:
  /// - setup a payment intent
  /// - show the payment UI
  /// - process the payment and fullfill the order
  /// The server-side logic will be covered in course #2
  Future<void> placeOrder() async {
    final authRepository = ref.read(authRepositoryProvider);
    final remoteCartRepository = ref.read(remoteCartRepositoryProvider);
    final ordersRepository = ref.read(ordersRepositoryProvider);
    // * Assertion operator is ok here since this method is only called from
    // * a place where the user is signed in
    final uid = authRepository.currentUser!.uid;
    // 1. Get the cart object
    final cart = await remoteCartRepository.fetchCart(uid);
    final total = _totalPrice(cart);
    // * If we want to make this code more testable, a DateTime builder
    // * should be injected as a dependency
    final orderDate = DateTime.now();
    // * The orderId is a unique string that could be generated with the UUID
    // * package. Since this is a fake service, we just derive it from the date.
    final orderId = orderDate.toIso8601String();
    // 2. Create an order
    final order = Order(
      id: orderId,
      userId: uid,
      items: cart.items,
      orderStatus: OrderStatus.confirmed,
      orderDate: orderDate,
      total: total,
    );
    // 3. Save it using the repository
    await ordersRepository.addOrder(uid, order);
    // 4. Empty the cart
    await remoteCartRepository.setCart(uid, const Cart());
  }

  // Helper method to calculate the total price
  double _totalPrice(Cart cart) {
    if (cart.items.isEmpty) {
      return 0.0;
    }
    final producsRepository = ref.read(productsRepositoryProvider);
    return cart.items.entries
        // first extract quantity * price for each item
        .map((entry) =>
            entry.value * // quantity
            producsRepository.getProductById(entry.key)!.price) // price
        // then add them up
        .reduce((value, element) => value + element);
  }
}

final checkoutServiceProvider = Provider<FakeCheckoutService>((ref) {
  return FakeCheckoutService(ref);
});
