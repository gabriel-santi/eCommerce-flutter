import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  late MockAuthRepository authRepository;
  final testEmail = "test@email.com";
  final testPassword = "password123";

  setUp(() {
    authRepository = MockAuthRepository();
  });

  group("Sign in ", () {
    testWidgets('''
      Given formType is signIn
      When tap on the sign-in button
      Then signInWithEmailAndPassword is not called
    ''', (tester) async {
      final r = AuthRobot(tester);
      await r.pumpEmailPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
      );
      verifyNever(
        () => authRepository.signInWithEmailAndPassword(any(), any()),
      );
    });

    testWidgets('''
      Given formType is signIn
      When enter valid email and password 
      And tap on the sign-in button
      Then onSignIn callback is called
      And error popup not found
    ''', (tester) async {
      bool didSignIn = false;
      final r = AuthRobot(tester);
      when(() => authRepository.signInWithEmailAndPassword(
          testEmail, testPassword)).thenAnswer((_) => Future.value());
      await r.pumpEmailPasswordSignInContents(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.signIn,
          onSignIn: () => didSignIn = true);
      await r.enterEmail(testEmail);
      await r.enterPassword(testPassword);
      await r.tapEmailPasswordSubmitButton();
      verify(
        () =>
            authRepository.signInWithEmailAndPassword(testEmail, testPassword),
      ).called(1);
      r.expectErrorDialogNotFound();
      expect(didSignIn, true);
    });
  });
}
