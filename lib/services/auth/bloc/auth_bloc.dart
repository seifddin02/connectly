import 'package:connectly/services/auth/auth_provider.dart';
import 'package:connectly/services/auth/bloc/auth_event.dart';
import 'package:connectly/services/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    //Initialize event
    on<AuthEventInit>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNotVerified(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });
    //Log in event
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(const AuthStateLoggedOut(
            exception: null, isLoading: true, loadingText: 'Logging in'));
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.logIn(email: email, password: password);
          if (!user.isEmailVerified) {
            emit(const AuthStateLoggedOut(exception: null, isLoading: false));
            emit(const AuthStateNotVerified(isLoading: false));
          } else {
            emit(const AuthStateLoggedOut(exception: null, isLoading: false));
            emit(AuthStateLoggedIn(user: user, isLoading: false));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );
    //google
    // Google Sign-In event
    on<AuthEventGoogleSignIn>((event, emit) async {
      // Emitting state to show loading while signing in
      emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: 'Signing in with Google'));

      try {
        // Call a method to handle Google Sign-In from the provider
        final user = await provider.signInWithGoogle();

        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    //Send email verificaion
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state);
      },
    );
    //REgister
    on<AuthEvenRegister>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        try {
          await provider.registerUser(email: email, password: password);
          await provider.sendEmailVerification();
          emit(const AuthStateNotVerified(isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateRegistering(exception: e, isLoading: false));
        }
      },
    );
    //Should register
    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(const AuthStateRegistering(exception: null, isLoading: false));
      },
    );
    //logout
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });
    //Forgot password
    on<AuthEventForgotPasswprd>(
      (event, emit) async {
        emit(const AuthStateForgotPassword(
            exception: null, hasSentEmail: false, isLoading: false));
        final email = event.email;
        if (email == null) {
          return;
        }
        emit(const AuthStateForgotPassword(
            exception: null, hasSentEmail: false, isLoading: true));
        bool emailSent;
        Exception? exception;
        try {
          await provider.sendPasswordReset(email: email);
          emailSent = true;
          exception = null;
        } on Exception catch (e) {
          emailSent = false;
          exception = e;
        }
        emit(AuthStateForgotPassword(
            exception: exception, hasSentEmail: emailSent, isLoading: false));
      },
    );
  }
}
