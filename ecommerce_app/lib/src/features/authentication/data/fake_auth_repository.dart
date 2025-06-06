import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/authentication/data/auth_repository.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.addDelay = true});
  final bool addDelay;
  final _authState = InMemoryStore<AppUser?>(null);

  @override
  AppUser? get currentUser => _authState.value;

  @override
  Stream<AppUser?> authStateChanges() => _authState.stream;

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await delay(addDelay);
    _createNewUser(email);
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);
    _createNewUser(email);
  }

  @override
  Future<void> signOut() async {
    await delay(addDelay);
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createNewUser(String email) {
    _authState.value =
        AppUser(uid: email.split('').reversed.join(), email: email);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FakeAuthRepository();
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges();
});
