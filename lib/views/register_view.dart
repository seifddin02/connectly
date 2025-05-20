import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectly/components/my_button.dart';
import 'package:connectly/components/my_textfield.dart';
import 'package:connectly/services/auth/auth_exception.dart';
import 'package:connectly/services/auth/bloc/auth_bloc.dart';
import 'package:connectly/services/auth/bloc/auth_event.dart';
import 'package:connectly/services/auth/bloc/auth_state.dart';
import 'package:connectly/utilities/dialogs/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmpassword;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmpassword = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmpassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid emial');
          } else if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email already in use');
          } else if (state.exception is ChannelErrorAuthException) {
            await showErrorDialog(context, 'Please enter email and password');
          } else if (state.exception is PasswordAndConfirmDontMatch) {
            await showErrorDialog(
                context, 'Password and confirm password do not match');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Error registering account');
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
                    const SizedBox(height: 20),

                    //logo
                    //const Icon(Icons.lock, size: 100),
                    Image.asset('lib/images/perfect.png', height: 130),

                    //welcome
                    const SizedBox(height: 40),
                    Text('Welcome to connectly',
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
                    const SizedBox(height: 20),

                    //forgot password
                    const SizedBox(height: 20),

                    //sign in button
                    MyButton(
                      texty: 'Sign Up',
                      onTap: () async {
                        final email = _email.text
                            .trim(); // trim because if you let your keyboard autofill email it will append a space
                        final password = _password.text;
                        context
                            .read<AuthBloc>()
                            .add(AuthEvenRegister(email, password));
                      },
                    ),

                    const SizedBox(height: 40),

                    //continue with google

                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Or Sign up with',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Theme.of(context).colorScheme.surface,
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
                          'Already a member?',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        GestureDetector(
                          onTap: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventLogOut());
                          },
                          child: const Text(
                            'Login here',
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
