import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final firebaseAuthStateProvider = StreamProvider<User?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges();
});

class AuthState {
  final User? user;
  final bool loading;
  final String? error;

  AuthState({this.user, this.loading = false, this.error});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref)
    : super(AuthState(user: null, loading: false, error: null)) {
    ref.listen<AsyncValue<User?>>(firebaseAuthStateProvider, (prev, next) {
      next.whenData((user) {
        state = AuthState(user: user, loading: false);
      });
    });
  }

  Future<void> signIn(String email, String password) async {
    state = AuthState(user: state.user, loading: true);
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.signIn(email: email, password: password);
      state = AuthState(user: user, loading: false);
    } catch (e) {
      state = AuthState(user: null, loading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    state = AuthState(user: state.user, loading: true);
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.signUp(email: email, password: password);
      state = AuthState(user: user, loading: false);
    } catch (e) {
      state = AuthState(user: null, loading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.signOut();
    state = AuthState(user: null, loading: false);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(ref);
});
