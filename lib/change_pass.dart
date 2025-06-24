import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({super.key});

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  TextEditingController current = TextEditingController();
  TextEditingController newpass = TextEditingController();
  Future<void> changepass() async {
    try {
      final user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        final Credential = EmailAuthProvider.credential(
          email: user.email!,
          password: current.text,
        );
        await user.reauthenticateWithCredential(Credential);
        await user.updatePassword(newpass.text);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Password change successfully")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Change Password",
              style: GoogleFonts.poppins(
                color: Colors.teal,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            TextField(
              controller: current,
              decoration: InputDecoration(
                hintText: "Current password",
                labelText: "Current password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                suffixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: newpass,
              decoration: InputDecoration(
                hintText: "New password",
                labelText: "New password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                suffixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Confirm Password",
                labelText: "Confirm password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                suffixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  changepass();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),

                child: Text(
                  "Change password",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
