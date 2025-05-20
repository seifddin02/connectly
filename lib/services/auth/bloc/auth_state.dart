import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:connectly/services/auth/auth_user.dart';

//outputs of the Auth Bloc
@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({required this.isLoading, this.loadingText = 'Loading....'});
}

class AuthStateUninitialized extends AuthState {
  // for when firebase is initializing
  const AuthStateUninitialized({required super.isLoading});
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;

  const AuthStateLoggedIn({required this.user, required super.isLoading});
}

class AuthStateNotVerified extends AuthState {
  const AuthStateNotVerified({required super.isLoading});
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;
  const AuthStateForgotPassword(
      {required this.exception,
      required this.hasSentEmail,
      required super.isLoading});
}

// Equatable to produce various mutations of the state
// for we might have diff conditions ex. no exception, isloading is true, or no execption loading false, yes exception loading false
class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut(
      {required this.exception, required super.isLoading, super.loadingText});

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;

  const AuthStateRegistering(
      {required this.exception, required super.isLoading});
}
