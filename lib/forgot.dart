import 'package:chatapp_with_firebase/services.dart';
import 'package:flutter/material.dart';


class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  TextEditingController emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailcontroller,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: "Enter your email",
                filled: true,
                fillColor: const Color.fromARGB(255, 241, 241, 241),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                forgot(email: emailcontroller.text, context: context);
              },
              child: Text("Send", style: TextStyle(color: Colors.teal)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 233, 236, 235),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
