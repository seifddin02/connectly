import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectly/services/auth/auth_service.dart';
import 'package:connectly/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';

class MyProfileView extends StatefulWidget {
  MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  late final FirebaseCloudStorage _userService;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _userService = FirebaseCloudStorage();
    userEmail = AuthService.firebase().currentUser?.email;
  }

  @override
  Widget build(BuildContext context) {
    if (userEmail == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
        ),
        body: const Center(
          child: Text('User is not logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _userService.getUserDetails(userID: userEmail!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading user data'));
          } else if (snapshot.hasData) {
            Map<String, dynamic>? user = snapshot.data!.data();
            if (user == null) {
              return const Center(child: Text('No user data found'));
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //profile pic
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.all(25),
                    child: const Icon(
                      Icons.person_3,
                      size: 64,
                    ),
                  ),

                  const SizedBox(height: 25),

                  //email and user name fields should go here
                  Text(
                    user['email'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),

                  Text('ID: ${user['id']}'),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No user data found'));
          }
        },
      ),
    );
  }
}
