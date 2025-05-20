import 'package:connectly/constants/routes.dart';
import 'package:connectly/services/auth/bloc/auth_bloc.dart';
import 'package:connectly/services/auth/firebase_auth_provider.dart';
import 'package:connectly/themes/theme_provider.dart';
import 'package:connectly/views/get_view.dart';
import 'package:connectly/views/home_page_view.dart';
import 'package:connectly/views/message_box_view.dart';
import 'package:connectly/views/profile_view.dart';
import 'package:connectly/views/setting_view.dart';
import 'package:connectly/views/users_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seif',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const GetView(),
      ),
      routes: {
        homeViewRoute: (context) => const HomePageView(),
        settingsViewRoute: (context) => const SettingView(),
        myProfileViewRoute: (context) => MyProfileView(),
        messageBoxViewRoute: (context) => const MessageBoxView(),
        allUsersViewRoute: (context) => const UsersView(),
      },
    );
  }
}
