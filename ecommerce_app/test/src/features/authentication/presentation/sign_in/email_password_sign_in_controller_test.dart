import 'package:ecommerce_app/src/features/authentication/data/auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  final testEmail = "test@email.com";
  final testPassword = "password123";

  group("Submit", () {
    test('''
    Given formType is signIn
    When signInWithEmailAndPassword succeeds
    Then return true
    And state is AsyncData''', () async {
      // setup
      final authRepo = MockAuthRepository();
      when(() => authRepo.signInWithEmailAndPassword(testEmail, testPassword))
          .thenAnswer((_) => Future.value());
      final controller = EmailPasswordSignInController(
        formType: EmailPasswordSignInFormType.signIn,
        authRepository: authRepo,
      );
      // expect later
      expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: AsyncLoading<void>(),
            ),
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: AsyncData<void>(null),
            ),
          ]));
      // run
      final result = await controller.submit(testEmail, testPassword);
      // verify
      expect(result, true);
    }, timeout: const Timeout(Duration(milliseconds: 500)));

    test('''
    Given formType is signIn
    When signInWithEmailAndPassword fails
    Then return false
    And state is AsyncError''', () async {
      // setup
      final authRepo = MockAuthRepository();
      final exception = Exception("Connection failed");
      when(() => authRepo.signInWithEmailAndPassword(testEmail, testPassword))
          .thenThrow((_) => exception);
      final controller = EmailPasswordSignInController(
        formType: EmailPasswordSignInFormType.signIn,
        authRepository: authRepo,
      );
      // expect later
      expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: AsyncLoading<void>(),
            ),
            predicate<EmailPasswordSignInState>((state) {
              expect(state.formType, EmailPasswordSignInFormType.signIn);
              expect(state.value.hasError, true);
              return true;
            }),
          ]));
      // run
      final result = await controller.submit(testEmail, testPassword);
      // verify
      expect(result, false);
    }, timeout: const Timeout(Duration(milliseconds: 500)));

    test('''
    Given formType is register
    When signInWithEmailAndPassword succeeds
    Then return true
    And state is AsyncData''', () async {
      // setup
      final authRepo = MockAuthRepository();
      when(() =>
              authRepo.createUserWithEmailAndPassword(testEmail, testPassword))
          .thenAnswer((_) => Future.value());
      final controller = EmailPasswordSignInController(
        formType: EmailPasswordSignInFormType.register,
        authRepository: authRepo,
      );
      // expect later
      expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: AsyncLoading<void>(),
            ),
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: AsyncData<void>(null),
            ),
          ]));
      // run
      final result = await controller.submit(testEmail, testPassword);
      // verify
      expect(result, true);
    }, timeout: const Timeout(Duration(milliseconds: 500)));

    test('''
    Given formType is register
    When signInWithEmailAndPassword fails
    Then return false
    And state is AsyncError''', () async {
      // setup
      final authRepo = MockAuthRepository();
      final exception = Exception("Connection failed");
      when(() => authRepo.signInWithEmailAndPassword(testEmail, testPassword))
          .thenThrow((_) => exception);
      final controller = EmailPasswordSignInController(
        formType: EmailPasswordSignInFormType.register,
        authRepository: authRepo,
      );
      // expect later
      expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: AsyncLoading<void>(),
            ),
            predicate<EmailPasswordSignInState>((state) {
              expect(state.formType, EmailPasswordSignInFormType.register);
              expect(state.value.hasError, true);
              return true;
            }),
          ]));
      // run
      final result = await controller.submit(testEmail, testPassword);
      // verify
      expect(result, false);
    }, timeout: const Timeout(Duration(milliseconds: 500)));
  });

  group("UpdateFormType", () {
    test('''
      Given formType is register
      When called with signIn
      Then state.formType is signIn
    ''', () {
      // setup
      final authRepo = MockAuthRepository();
      final controller = EmailPasswordSignInController(
        formType: EmailPasswordSignInFormType.register,
        authRepository: authRepo,
      );
      // run
      controller.updateFormType(EmailPasswordSignInFormType.signIn);
      // verify
      expect(
        controller.debugState,
        EmailPasswordSignInState(
          formType: EmailPasswordSignInFormType.signIn,
          value: AsyncData<void>(null),
        ),
      );
    }, timeout: const Timeout(Duration(milliseconds: 500)));

    test('''
      Given formType is signIn
      When called with register
      Then state.formType is register
    ''', () {
      // setup
      final authRepo = MockAuthRepository();
      final controller = EmailPasswordSignInController(
        formType: EmailPasswordSignInFormType.signIn,
        authRepository: authRepo,
      );
      // run
      controller.updateFormType(EmailPasswordSignInFormType.register);
      // verify
      expect(
        controller.debugState,
        EmailPasswordSignInState(
          formType: EmailPasswordSignInFormType.register,
          value: AsyncData<void>(null),
        ),
      );
    }, timeout: const Timeout(Duration(milliseconds: 500)));
  });
}
