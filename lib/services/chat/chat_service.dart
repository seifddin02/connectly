import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectly/models/message.dart';
import 'package:connectly/services/auth/firebase_auth_provider.dart';

class ChatService {
  // get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthProvider _authProvider = FirebaseAuthProvider();
  String? userEmail;

  // get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
// go trough each individual user and return that user
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  //method send msg
  Future<void> sendMsg(String receiverEmail, String message) async {
    final String currentUEmail = _authProvider.currentUser!.email;
    final Timestamp timesstamp = Timestamp.now();

    //creat msg
    Message newMessage = Message(
        senderEmail: currentUEmail,
        receiverEmail: receiverEmail,
        message: message,
        timesstamp: timesstamp);

        s

    List<String> ids = [currentUEmail, receiverEmail];
    ids.sort(); // sort ensures uniqueness
    String chatRoomId = ids.join('_');

    //add to database

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMaP());
  }

  //metod recieve msg

  Stream<QuerySnapshot> getMsg(String receiverEmail, String senderEmail) {
    List<String> emails = [senderEmail, receiverEmail];
    emails.sort();
    String chatRoomId = emails.join('_');
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
