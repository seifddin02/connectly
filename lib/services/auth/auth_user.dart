import 'package:firebase_auth/firebase_auth.dart' as fire_base_auth show User;
import 'package:flutter/material.dart';

@immutable //all its var values and for its sublasses are final and cant be changed
class AuthUser {
  final bool isEmailVerified;
  final String email;
  final String id;

  const AuthUser(
      {required this.id, required this.isEmailVerified, required this.email});

  factory AuthUser.fromFireBase(fire_base_auth.User user) => AuthUser(
      id: user.uid, email: user.email!, isEmailVerified: user.emailVerified);
}
