import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectly/helpers/loading/loading_screen.dart';
import 'package:connectly/services/auth/bloc/auth_bloc.dart';
import 'package:connectly/services/auth/bloc/auth_event.dart';
import 'package:connectly/services/auth/bloc/auth_state.dart';
import 'package:connectly/views/forgot_password_view.dart';
import 'package:connectly/views/home_page_view.dart';
import 'package:connectly/views/login_view.dart';
import 'package:connectly/views/register_view.dart';
import 'package:connectly/views/verifyemail_view.dart';

class GetView extends StatelessWidget {
  const GetView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInit());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen()
              .show(context: context, text: state.loadingText ?? 'Loading...');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const HomePageView();
        } else if (state is AuthStateNotVerified) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else {
          return const Text('yoooooooo');
        }
      },
    );
  }
}
