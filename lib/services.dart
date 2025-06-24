import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:chatapp_with_firebase/chat_list.dart';
import 'package:chatapp_with_firebase/loginpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' hide Uint8List;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
Future<String?> uploadProfile(
  XFile profileimg,
  Uint8List? webimg,
  BuildContext context,
) async {
  const cloudinaryUrl = "https://api.cloudinary.com/v1_1/dikbnjnt0/image/upload";
  const presetName = "profile_image";

  try {
    final request = http.MultipartRequest("POST", Uri.parse(cloudinaryUrl));
    request.fields["upload_preset"] = presetName;

    if (kIsWeb && webimg != null) {
      final base64Image = base64Encode(webimg);
      request.fields["file"] = "data:image/png;base64,$base64Image";
    } else {
      final fileBytes = await profileimg.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        "file",
        fileBytes,
        filename: profileimg.name,
      );
      request.files.add(multipartFile);
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);
      return jsonData["secure_url"];
    } else {
      print("Cloudinary upload failed: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Upload error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Upload failed: ${e.toString()}")),
    );
    return null;
  }
}

Future<void> signup({
  required String name,
  required String email,
  required String password,
  required String confirmpassword,
  XFile? prfileimg,
  Uint8List? webimg,
  required BuildContext context,
}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    String? imageurl;
    if (prfileimg != null) {
      imageurl = await uploadProfile(prfileimg, webimg, context);
    }
    await FirebaseFirestore.instance.collection("users").doc(user?.uid).set({
      "name": name,
      "email": email,
      "profileimage": imageurl,
      "uid":user?.uid,
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

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatList()),
    );
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
