import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  late final MockAuthRepository authRepository;
  final testEmail = "test@email.com";
  final testPassword = "password123";

  setUp(() {
    authRepository = MockAuthRepository();
  });

  group("Sign in ", () async {
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
  });
}
