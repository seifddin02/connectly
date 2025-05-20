import 'package:connectly/services/auth/auth_provider.dart';
import 'package:connectly/services/auth/auth_user.dart';
import 'package:connectly/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService({required this.provider});
  factory AuthService.firebase() {
    return AuthService(provider: FirebaseAuthProvider());
  }

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    return provider.logIn(email: email, password: password);
  }

  @override
  Future<void> logOut() {
    return provider.logOut();
  }

  @override
  Future<AuthUser> registerUser(
      {required String email, required String password}) {
    return provider.registerUser(email: email, password: password);
  }

  @override
  Future<void> sendEmailVerification() {
    return provider.sendEmailVerification();
  }

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<void> sendPasswordReset({required String email}) {
    return provider.sendPasswordReset(email: email);
  }

  @override
  Future<AuthUser> signInWithGoogle() {
    return provider.signInWithGoogle();
  }
}
