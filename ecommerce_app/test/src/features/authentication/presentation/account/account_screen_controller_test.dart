@Timeout(Duration(milliseconds: 500))
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  group("AccountScreenController", () {
    test(
      "Initial state value shoud be null",
      () {
        final authRepo = MockAuthRepository();
        final controller = AccountScreenController(authRepository: authRepo);
        verifyNever(authRepo.signOut);
        expect(controller.debugState, const AsyncData<void>(null));
      },
      tags: ['unit'],
    );

    test(
      "SignOut successfuly",
      () async {
        //setup
        final authRepo = MockAuthRepository();
        when(authRepo.signOut).thenAnswer((invocation) => Future.value());
        final controller = AccountScreenController(authRepository: authRepo);
        expectLater(
            controller.stream,
            emitsInOrder([
              AsyncLoading<void>(),
              AsyncData<void>(null),
            ]));
        // run
        await controller.signOut();
        //verify
        verify(authRepo.signOut).called(1);
      },
      tags: ['unit'],
    );

    test(
      "SignOut failure",
      () async {
        //setup
        final authRepo = MockAuthRepository();
        final exception = Exception("Connection failed");
        when(authRepo.signOut).thenThrow(exception);
        final controller = AccountScreenController(authRepository: authRepo);
        expectLater(
          controller.stream,
          emitsInOrder([
            AsyncLoading<void>(),
            predicate<AsyncValue<void>>((value) {
              expect(value.hasError, true);
              return true;
            })
          ]),
        );
        // run
        await controller.signOut();
        //verify
        verify(authRepo.signOut).called(1);
      },
      tags: ['unit'],
    );
  });
}
