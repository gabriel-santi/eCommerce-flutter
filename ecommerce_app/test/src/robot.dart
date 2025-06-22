import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class Robot {
  Robot(this.tester);
  final WidgetTester tester;

  Future<void> pumpMyApp() async {
    // create new repositories with addDelay: false
    final authRepository = FakeAuthRepository(addDelay: false);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
      child: const MyApp(),
    ));
    await tester.pumpAndSettle();
  }
}
