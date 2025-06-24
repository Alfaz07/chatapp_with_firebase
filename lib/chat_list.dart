import 'package:chatapp_with_firebase/change_pass.dart';
import 'package:chatapp_with_firebase/chat_screen.dart';
import 'package:chatapp_with_firebase/loginpage.dart';
import 'package:chatapp_with_firebase/my_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final String userid = FirebaseAuth.instance.currentUser!.uid;

  // Helper to generate same chatId for both users
  String getChatId(String id1, String id2) {
    return id1.hashCode <= id2.hashCode ? '$id1\_$id2' : '$id2\_$id1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat List"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == "change password") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePass()),
                );
              } else if (value == "My Profile") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyProfile()),
                );
              } else if (value == "Log out") {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "change password",
                child: Row(
                  children: const [
                    Icon(Icons.lock, color: Colors.black),
                    SizedBox(width: 10),
                    Text("Change Password"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "My Profile",
                child: Row(
                  children: const [
                    Icon(Icons.person, color: Colors.black),
                    SizedBox(width: 10),
                    Text("My Profile"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "Log out",
                child: Row(
                  children: const [
                    Icon(Icons.logout, color: Colors.black),
                    SizedBox(width: 10),
                    Text("Log Out"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          final users = snapshot.data!.docs
              .where((doc) => doc["uid"] != userid)
              .toList();

          if (users.isEmpty) {
            return const Center(child: Text("No other users found"));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final chatId = getChatId(userid, user['uid']);

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['profileimage'] ?? ''),
                ),
                title: Text(user['name'] ?? 'Unknown'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        chatId: chatId,
                        currentUserId: userid,
                        receverId: user['uid'],
                        reciverImage: user['profileimage'] ?? '',
                        reciverName: user['name'] ?? 'Unknown',
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
