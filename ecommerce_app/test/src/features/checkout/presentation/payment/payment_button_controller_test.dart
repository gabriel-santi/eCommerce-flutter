import 'package:ecommerce_app/src/features/checkout/presentation/payment/payment_button_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  group('payment button controller', () {
    test("Success", () async {
      final checkoutService = MockCheckoutService();
      when(() => checkoutService.placeOrder()).thenAnswer((_) => Future.value());

      final controller = PaymentButtonController(checkoutService: checkoutService);

      // run & verify
      expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            const AsyncData<void>(null),
          ]));
      await controller.pay();
    });

    test("Failure", () async {
      final checkoutService = MockCheckoutService();
      final exception = Exception('Cart Rejected');
      when(() => checkoutService.placeOrder()).thenThrow(exception);

      final controller = PaymentButtonController(checkoutService: checkoutService);
      expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            predicate<AsyncValue<void>>(
              (value) {
                expect(value.hasError, true);
                return true;
              },
            ),
          ]));
      // run & verify
      await controller.pay();
    });
  });
}
