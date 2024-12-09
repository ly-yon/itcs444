import 'package:flutter/material.dart';
import 'package:flutter_application_project/authProvider.dart';
import 'package:provider/provider.dart';

class marks extends StatelessWidget {
  const marks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('marks'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().signOut(); // Logs out the user
            },
          ),
        ],
      ),
      body: Text('marks',style: TextStyle(fontSize: 40),),
    );
  }
}
