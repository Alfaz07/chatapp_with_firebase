import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String receverId;
  final String reciverName;
  final String reciverImage;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.receverId,
    required this.reciverImage,
    required this.reciverName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgController = TextEditingController();

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.reciverImage),
              radius: 18,
            ),
            const SizedBox(width: 10),
            Text(widget.reciverName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/41919.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(widget.chatId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No messages yet."));
                  }

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe =
                          message['senderId'] == widget.currentUserId;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.teal.withOpacity(0.8)
                                : const Color.fromARGB(255, 96, 125, 139),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Text(
                            message['text'],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // Input Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 240, 225, 225),
                      hintText: "Say something...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (text) => setState(() {}),
                  ),
                ),
                IconButton(
                  onPressed: msgController.text.trim().isNotEmpty
                      ? () {
                          sendMessage(msgController.text.trim());
                        }
                      : null,
                  icon: Icon(
                    Icons.send,
                    color: msgController.text.trim().isNotEmpty
                        ? Colors.blue
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String messageText) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
      'text': messageText,
      'senderId': widget.currentUserId,
      'receiverId': widget.receverId,
      'timestamp': FieldValue.serverTimestamp(),
    });
    msgController.clear();
    setState(() {});
  }
}
