import 'package:connectly/constants/routes.dart';
import 'package:connectly/services/auth/bloc/auth_bloc.dart';
import 'package:connectly/services/auth/bloc/auth_event.dart';
import 'package:connectly/utilities/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // logo
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Image.asset('lib/images/perfect.png', height: 130),
                ),
              ),

              //home list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text('H O M E'),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      homeViewRoute,
                      (route) => false,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text('M E S S A G E S'),
                  leading: const Icon(Icons.message),
                  onTap: () {
                    Navigator.of(context).pushNamed(messageBoxViewRoute);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text('M Y P R O F I L E'),
                  leading: const Icon(Icons.person),
                  onTap: () {
                    Navigator.of(context).pushNamed(myProfileViewRoute);
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text('S E T T I N G S'),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(settingsViewRoute);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text('users'),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(allUsersViewRoute);
                  },
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              title: const Text('L O G O U T'),
              leading: const Icon(Icons.logout),
              onTap: () async {
                final shouldLogout = await showLogoutDialog(context);
                if (shouldLogout) {
                  if (!context.mounted) return;
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                }
              },
            ),
          ),

          // settings listtile

          //logout
        ],
      ),
    );
  }
}
