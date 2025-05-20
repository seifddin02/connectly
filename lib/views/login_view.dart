import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectly/components/my_button.dart';
import 'package:connectly/components/my_textfield.dart';
import 'package:connectly/services/auth/auth_exception.dart';
import 'package:connectly/services/auth/bloc/auth_bloc.dart';
import 'package:connectly/services/auth/bloc/auth_event.dart';
import 'package:connectly/services/auth/bloc/auth_state.dart';
import 'package:connectly/utilities/dialogs/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is InvalidCredentialsAuthException) {
            await showErrorDialog(context, 'Invalid credentials');
          } else if (state.exception is ChannelErrorAuthException) {
            await showErrorDialog(context, 'Please put an email and password');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),

                    //logo
                    //const Icon(Icons.lock, size: 100),
                    Image.asset('lib/images/perfect.png', height: 130),

                    //welcome
                    const SizedBox(height: 50),
                    Text('Welcome back!',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.shadow,
                            fontSize: 16)),

                    //text fields
                    const SizedBox(height: 25),
                    //email field

                    MyTextField(
                        controller: _email,
                        hintText: 'Email address',
                        obscureText: false),

                    const SizedBox(height: 10),
                    //password field

                    MyTextField(
                        controller: _password,
                        hintText: 'Password',
                        obscureText: true),
                    //forgot password
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventForgotPasswprd(null));
                          },
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    //sign in button
                    MyButton(
                      texty: 'Sign in',
                      onTap: () async {
                        final email = _email.text
                            .trim(); // trim because if you let your keyboard autofill email it will append a space
                        final password = _password.text;
                        context
                            .read<AuthBloc>()
                            .add(AuthEventLogIn(email, password));
                      },
                    ),

                    const SizedBox(height: 50),

                    //continue with google

                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Or Sign in with',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () {
                        context
                            .read<AuthBloc>()
                            .add(const AuthEventGoogleSignIn());
                      },
                      child: Image.asset(
                        'lib/images/google.png',
                        height: 82,
                      ),
                    ),
                    const SizedBox(height: 40),

                    //not registerd
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        GestureDetector(
                          onTap: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventShouldRegister());
                          },
                          child: const Text(
                            'Register now',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
