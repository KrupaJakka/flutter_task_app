import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/firebase_auth_service.dart';

class AuthRepository {
  final FirebaseAuthService _service;

  AuthRepository({FirebaseAuthService? service})
    : _service = service ?? FirebaseAuthService();

  Stream<User?> authStateChanges() {
    return _service.authStateChanges;
  }

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    return await _service.signIn(email, password);
  }

  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    return await _service.register(email, password);
  }

  Future<void> signOut() async {
    await _service.signOut();
  }
}
