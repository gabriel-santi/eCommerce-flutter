import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  testWidgets(
    'Cancel logout',
    (tester) async {
      final r = AuthRobot(tester);
      await r.pumpAccountScreen();
      await r.tapLogoutButton();
      r.expectLogoutDialogFound();
      await r.tapCancelButton();
      r.expectLogoutDialogNotFound();
      r.expectErrorDialogNotFound();
    },
    tags: ['widgets'],
  );

  testWidgets(
    'Confirm logout, success',
    (tester) async {
      final r = AuthRobot(tester);
      await r.pumpAccountScreen();
      await r.tapLogoutButton();
      r.expectLogoutDialogFound();
      await r.tapDialogLogoutButton();
      r.expectLogoutDialogNotFound();
      r.expectErrorDialogNotFound();
    },
    tags: ['widgets'],
  );

  testWidgets(
    'Confirm logout, failure',
    (tester) async {
      final r = AuthRobot(tester);
      final authRepository = MockAuthRepository();
      final exception = Exception("Connection failed");
      when(authRepository.signOut).thenThrow(exception);
      when(authRepository.authStateChanges)
          .thenAnswer((_) => Stream.value(null));
      await r.pumpAccountScreen(authRepository: authRepository);
      await r.tapLogoutButton();
      r.expectLogoutDialogFound();
      await r.tapDialogLogoutButton();
      r.expectErrorDialogFound();
    },
    tags: ['widgets'],
  );

  testWidgets(
    'Confirm logout loading state',
    (tester) async {
      final r = AuthRobot(tester);
      final authRepository = MockAuthRepository();
      when(authRepository.signOut)
          .thenAnswer((_) => Future.delayed(const Duration(seconds: 1)));
      when(authRepository.authStateChanges)
          .thenAnswer((_) => Stream.value(null));
      await tester.runAsync(() async {
        await r.pumpAccountScreen(authRepository: authRepository);
        await r.tapLogoutButton();
        r.expectLogoutDialogFound();
        await r.tapDialogLogoutButton();
      });
      r.expectErrorDialogNotFound();
      r.expectCircularProgressIndicator();
    },
    tags: ['widgets'],
  );
}
