import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String? chatId; // didapat dari proses pairing user dengan relawan
  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  void sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
          'text': _controller.text.trim(),
          'senderId': user!.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.chatId == null || widget.chatId!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Chat Konseling")),
        body: Center(
          child: Text(
            'Belum ada sesi chat aktif.\nTunggu pairing dengan relawan.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Chat Konseling")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('chats')
                      .doc(widget.chatId)
                      .collection('messages')
                      .orderBy('timestamp')
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;

                return ListView(
                  reverse: true,
                  children:
                      messages.reversed.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final isMe = data['senderId'] == user!.uid;

                        return Container(
                          alignment:
                              isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue[100] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(data['text']),
                          ),
                        );
                      }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Tulis pesan..."),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
