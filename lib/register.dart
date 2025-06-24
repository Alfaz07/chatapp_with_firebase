import 'dart:io';
import 'package:chatapp_with_firebase/services.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController confpasscontroller = TextEditingController();
  final ImagePicker imageimp = ImagePicker();
  XFile? _profileImage;
  Uint8List? _webimage;
  Future<void> pickimage() async {
    final pickedfile = await imageimp.pickImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      if (kIsWeb) {
        Uint8List imagebytes = await pickedfile.readAsBytes();
        setState(() {
          _webimage = imagebytes;
          _profileImage = pickedfile;
        });
      } else {
        setState(() {
          _profileImage = pickedfile;
        });
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Image is Required")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 400,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "REGISTER",

                style: GoogleFonts.poppins(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              SizedBox(height: 40),
              Image.asset("assets/images/image2.jpg", width: 200, height: 200),
              GestureDetector(
                onTap: pickimage,
                child: CircleAvatar(
                  backgroundColor: Colors.teal,
                  backgroundImage: _profileImage != null
                      ? (kIsWeb
                            ? MemoryImage(_webimage!)
                            : FileImage(File(_profileImage!.path))
                                  as ImageProvider)
                      : null,
                  child: _profileImage == null
                      ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                      : null,
                  radius: 50,
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: namecontroller,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: "Enter you name",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextField(
                controller: emailcontroller,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  hintText: "Enter you Email",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passcontroller,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: "password",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: confpasscontroller,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: "confirm password",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
              ),
              SizedBox(height: 15),

              Text(
                "already have an account?",
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 15),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    signup(
                      name: namecontroller.text,
                      email: emailcontroller.text,
                      password: passcontroller.text,
                      confirmpassword: confpasscontroller.text,
                      prfileimg: _profileImage,
                      context: context,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(30),
                    ),
                  ),
                  child: Text(
                    "SIGNUP",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
