import 'package:flutter/material.dart';

//input to the Auth Bloc
@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInit extends AuthEvent {
  const AuthEventInit();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogIn(this.email, this.password);
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEvenRegister extends AuthEvent {
  final String email;
  final String password;
  const AuthEvenRegister(this.email, this.password);
}

class AuthEventForgotPasswprd extends AuthEvent {
  final String? email;
  const AuthEventForgotPasswprd(this.email);
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventGoogleSignIn extends AuthEvent {
  const AuthEventGoogleSignIn();
}
