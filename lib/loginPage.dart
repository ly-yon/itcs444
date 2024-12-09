import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_application_project/AuthService.dart';
import 'signUpPage.dart';

import 'package:provider/provider.dart';
import 'authProvider.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;

  AuthService authService = AuthService();

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A364E),
      appBar: AppBar(
        title: Center(
          child: Text(
            'Login Page',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 8.0), // Adjust padding as needed
            child: Image.asset(
              'assets/logo.png', // Replace with the path to your image asset
              height: 45, // Adjust the height of the image
              width: 45, // Adjust the width of the image
            ),
          ),
        ],
        backgroundColor: Color(0xFFE9EDF6), // Hex color #e9edf6
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(), // Set margin for all sides
          padding: EdgeInsets.only(), // Set padding for all sides
          width: 360, // Set width of the container
          height: 390, // Set height of the container
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color(0xFFE9EDF6),
          ),
          child: Container(
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 10,
              ),
              padding: EdgeInsets.only(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.only(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 50, left: 50),
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "Sign in to continue",
                              textAlign:
                                  TextAlign.center, // Center-align the text
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF1C2120),
                              ),
                              softWrap:
                                  true, // Allow text to wrap to the next line
                              maxLines:
                                  2, // Limit the number of lines if needed
                              overflow: TextOverflow
                                  .ellipsis, // Add ellipsis if the text overflows
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 27,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email TextField
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            errorText: _emailError,
                            errorStyle: TextStyle(
                              fontSize: 11, // Adjust the font size
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                    Color(0xFF8F8E8E), // Passive border color
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            setState(() {
                              _emailError = null; // Reset error when typing
                            });
                          },
                        ),
                        SizedBox(height: 10),

                        // Password TextField
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            errorText: _passwordError,
                            errorStyle: TextStyle(
                              fontSize: 11, // Adjust the font size
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                    Color(0xFF8F8E8E), // Passive border color
                              ),
                            ),
                          ),
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              _passwordError = null; // Reset error when typing
                            });
                          },
                        ),
                        SizedBox(height: 12),

                        // login Button
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              // Email validation
                              if (_emailController.text.isEmpty) {
                                _emailError = "Email cannot be empty";
                              } else if (!_validateEmail(
                                  _emailController.text)) {
                                _emailError = "Please enter a valid email";
                              } else {
                                _emailError = null; // No error
                              }

                              // Password validation
                              if (_passwordController.text.isEmpty) {
                                _passwordError = "Password cannot be empty";
                              } else if (_passwordController.text.length < 8) {
                                _passwordError =
                                    "Password must be at least 8 characters long";
                              } else {
                                _passwordError = null; // No error
                              }
                            });

                            // If all validations pass
                            if (_emailError == null && _passwordError == null) {
                              // await authService.signIn(
                              //     _emailController.text.trim(),
                              //     _passwordController.text.trim());
                              final authProvider = context.read<AuthProvider>();
                              authProvider.login(_emailController.text.trim(),
                                  _passwordController.text.trim());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(20, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Color(
                                0xFF1C2120), // Example custom button color
                          ),
                          child: Text("login",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),

                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: RichText(
                              textAlign:
                                  TextAlign.center, // Center-align the text
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF1C2120),
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        "Do you have an account? ", // Static part of the text
                                  ),
                                  TextSpan(
                                    text:
                                        "SignUp here.", // Clickable part of the text
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 11, 94,
                                          162), // Change color for the link
                                      decoration: TextDecoration
                                          .underline, // Underline to make it look like a link
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Navigate to the login page
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  signUpPage()),
                                        );
                                      
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
