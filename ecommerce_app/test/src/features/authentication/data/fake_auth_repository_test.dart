import 'package:ecommerce_app/src/exceptions/app_exceptions.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final email = "test@email.com";
  final password = "password123";
  final testUser = AppUser(uid: email.split('').reversed.join(), email: email);
  FakeAuthRepository makeAuthRepository() => FakeAuthRepository(addDelay: false);
  group("FakeAuthRepository", () {
    test("current user is null", () {
      final authRepository = makeAuthRepository();
      addTearDown(authRepository.dispose);
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });
  });

  test('sign in throws when user not found', () async {
    final authRepository = makeAuthRepository();
    addTearDown(authRepository.dispose);
    await expectLater(
      () => authRepository.signInWithEmailAndPassword(email, password),
      throwsA(isA<UserNotFoundException>()),
    );
    expect(authRepository.currentUser, null);
    expect(authRepository.authStateChanges(), emits(null));
  });

  test("current user is not null after create", () async {
    final authRepository = makeAuthRepository();
    addTearDown(authRepository.dispose);
    await authRepository.createUserWithEmailAndPassword(email, password);
    expect(authRepository.currentUser, testUser);
    expect(authRepository.authStateChanges(), emits(testUser));
  });

  test("current user is null after sign out", () async {
    final authRepository = makeAuthRepository();
    addTearDown(authRepository.dispose);
    await authRepository.signInWithEmailAndPassword(email, password);
    expect(authRepository.currentUser, testUser);
    expect(authRepository.authStateChanges(), emits(testUser));

    await authRepository.signOut();
    expect(authRepository.currentUser, null);
    expect(authRepository.authStateChanges(), emits(null));
  });

  test("create user after dispose throws exception", () async {
    final authRepository = makeAuthRepository();
    addTearDown(authRepository.dispose);
    authRepository.dispose();
    expect(() async => await authRepository.createUserWithEmailAndPassword(email, password), throwsStateError);
  });
}
