import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:connectly/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudPost {
  final String documentId;
  final String ownerId;
  final String text;
  final Timestamp timesstamp;

  const CloudPost({
    required this.documentId,
    required this.ownerId,
    required this.text,
    required this.timesstamp,
  });

  CloudPost.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerId = snapshot.data()[ownerUserIdFieldName] as String,
        text = snapshot.data()[textFieldName] as String,
        timesstamp = snapshot.data()[timestampFieldName] as Timestamp;
}
