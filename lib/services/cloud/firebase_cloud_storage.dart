import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectly/services/auth/auth_user.dart';
import 'package:connectly/services/cloud/cloud_note.dart';
import 'package:connectly/services/cloud/cloud_storage_constants.dart';
import 'package:connectly/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final users = FirebaseFirestore.instance.collection('Users');
  final posts = FirebaseFirestore.instance.collection('Posts');

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  Future<void> createUserDocument(AuthUser? user) async {
    if (user == null) {
      throw Exception("User cannot be null");
    }
    await users.doc(user.email).set({'email': user.email, 'id': user.id});
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails(
      {required String userID}) async {
    try {
      final result = await users.doc(userID).get();
      return result;
    } catch (e) {
      throw CouldNotGetUserDetailsException();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> allUsers() {
    final allUsers = users.snapshots();
    return allUsers;
  }

  Future<CloudPost> createNewPost(
      {required String ownerUserId, required String text}) async {
    final document = await posts.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: text,
      timestampFieldName: Timestamp.now()
    });

    final fetchedNote = await document.get();
    return CloudPost(
        documentId: fetchedNote.id,
        ownerId: ownerUserId,
        text: text,
        timesstamp: Timestamp.now());
  }

  Future<void> updatePost(
      {required String documentId, required String text}) async {
    try {
      await posts.doc(documentId).update({textFieldName: text});
    } catch (_) {
      throw CouldNotUpdateNoteException();
    }
  }

  // Stream<Iterable<CloudPost>> allPosts({required String ownerUserId}) {
  //   final allPosts = posts
  //       //.where(ownerUserIdFieldName, isEqualTo: ownerUserId) late get only friends posts
  //       .orderBy('time_stamp', descending: true)
  //       .snapshots()
  //       .map((event) => event
  //           .docs // "event thing" transforms each snapshot event into a new value.
  //           .map((doc) => CloudPost.fromSnapshot(
  //               doc))); // map that value to a cloudpost obj
  //   return allPosts;
  // }
  Stream<Iterable<CloudPost>> allPosts() {
    final allPosts = posts
        //.where(ownerUserIdFieldName, isEqualTo: ownerUserId) late get only friends posts
        .orderBy('time_stamp', descending: true)
        .snapshots()
        .map((event) => event
            .docs // "event thing" transforms each snapshot event into a new value.
            .map((doc) => CloudPost.fromSnapshot(
                doc))); // map that value to a cloudpost obj
    return allPosts;
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await posts.doc(documentId).delete();
    } catch (_) {
      throw CouldNotDeletePostException();
    }
  }
}
