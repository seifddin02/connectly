import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderEmail;
  final String receiverEmail;
  final String message;
  final Timestamp timesstamp;

  Message(
      {required this.senderEmail,
      required this.receiverEmail,
      required this.message,
      required this.timesstamp});

  // convert to a map
  Map<String, dynamic> toMaP() {
    return {
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'message': message,
      'timestamp': timesstamp,
    };
  }
}
