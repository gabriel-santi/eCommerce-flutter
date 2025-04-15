import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthRepository {
  AppUser? get currentUser;

  Stream<AppUser?> authStateChanges();

  Future<void> signInWithEmailAndPassword(String email, String password);

  Future<void> createUserWithEmailAndPassword(String email, String password);

  Future<void> signOut();
}

class FakeAuthRepository implements AuthRepository {
  @override
  AppUser? get currentUser => throw UnimplementedError();

  @override
  Stream<AppUser?> authStateChanges() async* {
    // TODO: implement authStateChanges
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    // TODO: implement createUserWithEmailAndPassword
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    // TODO: implement signInWithEmailAndPassword
  }

  @override
  Future<void> signOut() async {
    // TODO: implement signOut
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FakeAuthRepository();
});

final authStateChangesProvider = Provider<Stream<AppUser?>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges();
});
