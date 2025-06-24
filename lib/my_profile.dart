import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  TextEditingController emailll = TextEditingController();
  TextEditingController namee = TextEditingController();
  bool isEiditing = false;
  late String name, email, profileimage;
  final formKey = GlobalKey<FormState>();
  Future<void> saveprofile() async {
    if (formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .update({'name': namee.text, 'email': emailll.text,"profileimage":profileimage});
        setState(() {
          isEiditing = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Profile Upated successfully!")));
      } catch (e) {
        print("Error upadting profile: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .where("uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .get(),
        builder: (context, Snapshot) {
          if (!Snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final User = Snapshot.data!.docs.first.data() as Map<String, dynamic>;
          name = User['name'] ?? '';
          email = User['email'] ?? '';
          profileimage = User['profileimage'] ?? '';
          namee.text = name;
          emailll.text = email;

          return Form(
            key: formKey,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.teal, Colors.white]),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(20),
                ),
                elevation: 8,
                margin: EdgeInsets.only(
                  top: 130,
                  bottom: 130,
                  left: 30,
                  right: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 80),

                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profileimage),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: textfield(namee, 'Name', Icons.person),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: textfield(emailll, 'Email', Icons.email),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 40,

                      child: ElevatedButton(
                        onPressed: () {
                          if (isEiditing) {
                            saveprofile();
                          } else {
                            setState(() {
                              isEiditing = true;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        child: Text(
                          isEiditing?"save":"edit",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget textfield(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        filled: true,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black),
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
