import 'package:flutter/material.dart';
import 'package:flutter_application_project/authProvider.dart';
import 'package:provider/provider.dart';

class createTest extends StatelessWidget {
  const createTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('createTestPage'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().signOut(); // Logs out the user
            },
          ),
        ],
      ),
      body: Text('createTest',style: TextStyle(fontSize: 40),),
    );
  }
}
