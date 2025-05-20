import 'package:connectly/services/auth/auth_service.dart';
import 'package:connectly/services/cloud/firebase_cloud_storage.dart';
import 'package:connectly/views/chat_view.dart';
import 'package:flutter/material.dart';

class MessageBoxView extends StatefulWidget {
  const MessageBoxView({super.key});

  @override
  State<MessageBoxView> createState() => _MessageBoxViewState();
}

class _MessageBoxViewState extends State<MessageBoxView> {
  late final FirebaseCloudStorage _userService;
  String? userEmail;

  @override
  void initState() {
    _userService = FirebaseCloudStorage();
    userEmail = AuthService.firebase().currentUser?.email;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: StreamBuilder(
        stream: _userService.allUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.data == null) {
            return const Text('nno data');
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              if (user['email'] == userEmail) {
                return Container();
              } else {
                return ListTile(
                  title: Text(
                    user['email'],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatView(
                            receiverEmail: user['email'],
                          ),
                        ));
                  },
                  trailing: const Icon(Icons.message),
                );
              }
            },
          );
        },
      ),
    );
  }
}
