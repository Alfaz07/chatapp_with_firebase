import 'package:chatapp_with_firebase/chat_list.dart';
import 'package:chatapp_with_firebase/loginpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


Future<void> signup({
  required String name,
  required String email,
  required String password,
  required String confirmpassword,
  required BuildContext context,
}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    await FirebaseFirestore.instance.collection("users").doc(user?.uid).set({
      "name": name,
      "email": email,
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("User created successfully")));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(e.toString())));
  }
}

Future<void> signin({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Login successfully")));

    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatList()));
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(e.toString())));
  }
}

Future<void> forgot({
  required String email,
  required BuildContext context,
}) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("check your mail")));
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(e.toString())));
  }
}

Future<void> addtodo({required text, required BuildContext context}) async {
  await FirebaseFirestore.instance.collection("todos").add({
    "text": text,

    "time": Timestamp.now(),
  });
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text("Added successfully")));
}

Stream<List<Map<String, dynamic>>> fetchtodos() {
  return FirebaseFirestore.instance
      .collection("todos")
      .orderBy("time", descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList(),
      );
}

Future<void> deletetodo(String id) async {
  await FirebaseFirestore.instance.collection("todos").doc(id).delete();
}

Future<void> updatetodo(String id, String text) async {
  await FirebaseFirestore.instance.collection("todos").doc(id).update({
    "text": text,
  });
}
