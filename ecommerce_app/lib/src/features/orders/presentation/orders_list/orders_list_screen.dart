import 'package:ecommerce_app/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app/src/features/orders/application/user_orders_provider.dart';
import 'package:ecommerce_app/src/features/orders/presentation/orders_list/order_card.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows the list of orders placed by the signed-in user.
class OrdersListScreen extends ConsumerWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'.hardcoded),
      ),
      body: Consumer(builder: (context, ref, _) {
        final orders = ref.watch(userOrdersProvider);

        return AsyncValueWidget(
          value: orders,
          onData: (orders) => orders.isEmpty
              ? Center(
                  child: Text(
                    'No previous orders'.hardcoded,
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                )
              : CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) => ResponsiveCenter(
                          padding: const EdgeInsets.all(Sizes.p8),
                          child: OrderCard(
                            order: orders[index],
                          ),
                        ),
                        childCount: orders.length,
                      ),
                    ),
                  ],
                ),
        );
      }),
    );
  }
}
