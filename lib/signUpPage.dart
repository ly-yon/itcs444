import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'loginPage.dart';
import 'home_page_admin.dart';
import 'package:provider/provider.dart';
import 'authProvider.dart';
import 'student_home_page.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({super.key});

  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _passwordConfirmationError;
  String? _roleError; // Error for role selection

  String? _selectedRole; // Holds the selected role
  final List<String> _roles = ["Student", "Admin"]; // Role options

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A364E),
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Center(
          child: Text(
            'SignUp Page',
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
          width: 350, // Set width of the container
          height: 700, // Set height of the container
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color(0xFFE9EDF6),
          ),
          child: Container(
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
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
                            'Create new Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
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
                                        "Already registered? ", // Static part of the text
                                  ),
                                  TextSpan(
                                    text:
                                        "Login here.", // Clickable part of the text
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 11, 94,
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
                                                  loginPage()),
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
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Name TextField
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: "Name",
                            errorText: _nameError,
                            errorStyle: TextStyle(fontSize: 11),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _nameError = null;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        // Email TextField
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            errorText: _emailError,
                            errorStyle: TextStyle(fontSize: 11),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _emailError = null;
                            });
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),

                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          items: _roles
                              .map((role) => DropdownMenuItem(
                                    value: role,
                                    child: Text(role),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value;
                              _roleError =
                                  null; // Clear error when role is selected
                            });
                          },
                          decoration: InputDecoration(
                            labelText: "Role",
                            errorText: _roleError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        // Password TextField
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            errorText: _passwordError,
                            errorStyle: TextStyle(fontSize: 11),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _passwordError = null;
                            });
                          },
                          obscureText: true,
                        ),
                        SizedBox(height: 16),
                        // Confirm Password TextField
                        TextField(
                          controller: _passwordConfirmationController,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            errorText: _passwordConfirmationError,
                            errorStyle: TextStyle(fontSize: 11),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _passwordConfirmationError = null;
                            });
                          },
                          obscureText: true,
                        ),
                        SizedBox(height: 16),
                        // Sign Up Button
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              // Validate role selection
                              if (_selectedRole == null) {
                                _roleError = "Please select a role";
                              }

                              // Name field
                              if (_nameController.text.isEmpty) {
                                _nameError = "Name cannot be empty";
                              } else if (_nameController.text.length < 3) {
                                _nameError =
                                    "Name is too small (min 3 characters)";
                              } else if (_nameController.text.length > 25) {
                                _nameError =
                                    "Name is too long (max 25 characters)";
                              } else {
                                _nameError = null;
                              }

                              // Email field
                              if (_emailController.text.isEmpty) {
                                _emailError = "Email cannot be empty";
                              } else if (!_validateEmail(
                                  _emailController.text)) {
                                _emailError = "Enter a valid email";
                              } else {
                                _emailError = null;
                              }

                              // Password field
                              if (_passwordController.text.isEmpty) {
                                _passwordError = "Password cannot be empty";
                              } else if (_passwordController.text.length < 8) {
                                _passwordError =
                                    "Password must be at least 8 characters";
                              } else {
                                _passwordError = null;
                              }

                              // Password confirmation field
                              if (_passwordConfirmationController
                                  .text.isEmpty) {
                                _passwordConfirmationError =
                                    "Please confirm your password";
                              } else if (_passwordConfirmationController
                                      .text.length <
                                  8) {
                                _passwordConfirmationError =
                                    "Password confirmation must be at least 8 characters";
                              } else if (_passwordConfirmationController.text !=
                                  _passwordController.text) {
                                _passwordConfirmationError =
                                    "Passwords do not match";
                              } else {
                                _passwordConfirmationError = null;
                              }
                            });

                            // If all validations pass
                            if (_nameError == null &&
                                _emailError == null &&
                                _passwordError == null &&
                                _passwordConfirmationError == null &&
                                _roleError == null) {
                              // await authService.createUser(
                              // _emailController.text.trim(),
                              // _passwordController.text.trim(),
                              // _nameController.text.trim(),
                              // _selectedRole!);
                              final authProvider = context.read<AuthProvider>();
                              final bool isAuth = await authProvider.signUp(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                  _nameController.text.trim(),
                                  _selectedRole!);
                              if (isAuth) {
                                if (authProvider.role == "Admin")
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const adminPage()),
                                    (Route route) => false,
                                  );
                                else {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const studentHome()),
                                    (Route route) => false,
                                  );
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(50, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Color(
                                0xFF1C2120), // Example custom button color
                          ),
                          child: Text("Sign Up",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
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
