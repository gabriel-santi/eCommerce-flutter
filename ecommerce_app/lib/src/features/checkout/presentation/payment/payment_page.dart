import 'package:ecommerce_app/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/presentation/shopping_cart/shopping_cart_item.dart';
import 'package:ecommerce_app/src/features/cart/presentation/shopping_cart/shopping_cart_items_builder.dart';
import 'package:ecommerce_app/src/features/checkout/presentation/payment/payment_button.dart';
import 'package:ecommerce_app/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Payment screen showing the items in the cart (with read-only quantities) and
/// a button to checkout.
class PaymentPage extends ConsumerWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(cartTotalPriceProvider, (_, cartTotal) {
      if (cartTotal == 0.0) {
        context.goNamed(AppRoute.orders.name);
      }
    });

    final cart = ref.watch(cartProvider);
    return AsyncValueWidget<Cart>(
        value: cart,
        onData: (cart) {
          return ShoppingCartItemsBuilder(
              items: cart.toItemsList(),
              itemBuilder: (_, item, index) => ShoppingCartItem(
                    item: item,
                    itemIndex: index,
                    isEditable: false,
                  ),
              ctaBuilder: (_) => const PaymentButton());
        });
  }
}
