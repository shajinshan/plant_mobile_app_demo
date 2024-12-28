import 'dart:convert';
import 'package:plant_sell/provider/userData.dart';
import 'package:plant_sell/screens/Register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:plant_sell/main.dart';
import 'package:provider/provider.dart';

class UserLogin extends StatefulWidget {
  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  bool passwordBtn = true;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String errorMsg = "";
  Future<void> loginUser(context) async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        errorMsg = "Enter email and password";
      });
      return;
    }
    const String registerApi = "http://localhost:8082/user/login";

    final response = await http.post(Uri.parse(registerApi),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "gmail": _emailController.text,
          "password": _passwordController.text
        }));

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      String uID = responseData['error'][0];

      Provider.of<UserDataModel>(context, listen: false).updateUserId(uID);
      Provider.of<UserDataModel>(context, listen: false)
          .updateLoginStatus(true);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    } else if (response.statusCode == 400) {
      setState(() {
        errorMsg = responseData['error'][0];
      });
    } else {
      print("error");
    }
  }

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
                  left: MediaQuery.of(context).size.width * 0.4,
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 28,
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
              "or use your Facebook account",
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
                    controller: _passwordController,
                    obscureText: passwordBtn,
                    decoration: InputDecoration(
                        hintText: " Password",
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
                  Text(
                    errorMsg,
                    style: TextStyle(color: Colors.red),
                  )
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
                loginUser(context);
              },
              child: const Text(
                "Login",
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
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RegisterUser();
                    }));
                  },
                  child: const Text(
                    "Register",
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
