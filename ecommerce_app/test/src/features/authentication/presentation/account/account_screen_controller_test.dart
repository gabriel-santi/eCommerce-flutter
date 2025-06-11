import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

void main() {
  group("AccountScreenController", () {
    test("Initial state value shoud be null", () {
      final authRepo = MockAuthRepository();
      final controller = AccountScreenController(authRepository: authRepo);
      verifyNever(authRepo.signOut);
      expect(controller.debugState, const AsyncData<void>(null));
    });

    test("SignOut successfuly", () async {
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
    });

    test("SignOut failure", () async {
      //setup
      final authRepo = MockAuthRepository();
      final exception = Exception("Connection failed");
      when(authRepo.signOut).thenThrow(exception);
      final controller = AccountScreenController(authRepository: authRepo);
      // run
      await controller.signOut();
      //verify
      verify(authRepo.signOut).called(1);
      expect(controller.debugState.hasError, true);
      expect(controller.debugState, isA<AsyncError>());
    });
  });
}
