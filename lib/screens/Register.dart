import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:plant_sell/screens/LoginUser.dart';

class RegisterUser extends StatefulWidget {
  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

TextEditingController _emailController = TextEditingController();
TextEditingController _phoneController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

bool regSucces = false;

Future<void> registerUser() async {
  const String registerApi = "http://localhost:8082/user/register";

  final response = await http.post(Uri.parse(registerApi),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "gmail": _emailController.text,
        "phone": _phoneController.text,
        "password": _passwordController.text
      }));

  if (response.statusCode == 200) {
    print("registerd");
    regSucces = true;
  } else {
    print("error");
  }
}

class _RegisterUserState extends State<RegisterUser> {
  bool passwordBtn = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                // Positioned(
                //   top: 80,
                //   left: MediaQuery.of(context).size.width * 0.3,
                //   child: Image.asset(
                //     'assets/images/aa.jpg',
                //     fit: BoxFit.cover, // Add an illustration here
                //     height: 120,
                //   ),
                // ),
                Positioned(
                  top: 220,
                  left: MediaQuery.of(context).size.width * 0.3,
                  child: const Text(
                    "Create New Account",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Social media icons
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.facebook,
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Text(
              "or use your email account",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: "E-mail",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                        hintText: "phone",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: passwordBtn,
                    decoration: InputDecoration(
                        hintText: "New Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordBtn = !passwordBtn;
                            });
                          },
                          icon: passwordBtn
                              ? Icon(Icons.abc)
                              : Icon(Icons.remove_red_eye),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(300, 50),
              ),
              onPressed: () {
                //register
                registerUser();
              },
              child: const Text(
                "REGISTER",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserLogin()));
                  },
                  child: const Text(
                    "Login here",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
