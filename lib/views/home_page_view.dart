import 'package:connectly/components/my_drawer.dart';
import 'package:connectly/components/my_post_button.dart';
import 'package:connectly/components/my_textfield.dart';
import 'package:connectly/services/auth/auth_service.dart';
import 'package:connectly/services/cloud/cloud_note.dart';
import 'package:connectly/services/cloud/firebase_cloud_storage.dart';
import 'package:connectly/views/posts_list_view.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late final TextEditingController _postTextController;
  late final FirebaseCloudStorage _postService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    super.initState();
    _postTextController = TextEditingController();
    _postService = FirebaseCloudStorage();
  }

  @override
  void dispose() {
    _postTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: _postTextController,
                    hintText: 'What\'s on your mind?',
                    obscureText: false,
                  ),
                ),
                MyPostButton(
                  ontap: () async {
                    final text = _postTextController.text;

                    if (text.isNotEmpty) {
                      await _postService.createNewPost(
                        ownerUserId: AuthService.firebase().currentUser!.email,
                        text: text,
                      );
                      _postTextController
                          .clear(); // Clear the text field after posting
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Post cannot be empty'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _postService.allPosts(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final allPosts = snapshot.data as Iterable<CloudPost>;
                      return PostsListView(posts: allPosts);
                    } else {
                      return const Center(child: Text('No posts yet'));
                    }
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
