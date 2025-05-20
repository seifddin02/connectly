import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectly/components/my_chat_bubble.dart';
import 'package:connectly/components/my_textfield.dart';
import 'package:connectly/services/auth/firebase_auth_provider.dart';
import 'package:connectly/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatView extends StatefulWidget {
  final String receiverEmail;

  const ChatView({super.key, required this.receiverEmail});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _msgController = TextEditingController();

  final ChatService _chatService = ChatService();

  final FirebaseAuthProvider _auth = FirebaseAuthProvider();

  //send msg
  void sendMessage() async {
    if (_msgController.text.isNotEmpty) {
      await _chatService.sendMsg(widget.receiverEmail, _msgController.text);

      _msgController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          //display msgs
          Expanded(
            child: _buildMsgList(),
          ),
          _buildUserInput()

          //text field input
        ],
      ),
    );
  }

  Widget _buildMsgList() {
    String senderEmail = _auth.currentUser!.email;
    return StreamBuilder(
      stream: _chatService.getMsg(widget.receiverEmail, senderEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No messages yet'));
        } else {
          return ListView(
            children:
                snapshot.data!.docs.map((doc) => _buildMsgItem(doc)).toList(),
          );
        }
      },
    );
  }

  Widget _buildMsgItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderEmail'] == _auth.currentUser!.email;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: MyChatBubble(
            message: data['message'], isCurrentUser: isCurrentUser));
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
              child: MyTextField(
            controller: _msgController,
            hintText: 'Message',
            obscureText: false,
          )),
          Container(
              decoration: const BoxDecoration(
                  color: Colors.green, shape: BoxShape.circle),
              margin: EdgeInsets.only(left: 10),
              child: IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  )))
        ],
      ),
    );
  }
}
