import 'package:flutter/material.dart';
import 'authProvider.dart';
import 'createTest.dart';
import 'homePage.dart';
import 'loginPage.dart';
import 'registerSelectionPage.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    print("0");
    print("Current user: ${authProvider.user?.email}");
    print("Current role: ${authProvider.role}");

    // if (authProvider.isLoading) {
    //   return Scaffold(body: Center(child: CircularProgressIndicator()));
    // }

    // If user state is still being determined, show loading spinner
    if (authProvider.user != null && authProvider.role == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (authProvider.user == null) {
      return homePage(); // Redirect to the home page if not authenticated
    }

    print("1");
    print("Current user: ${authProvider.user?.email}");
    print("Current role: ${authProvider.role}");

    if (authProvider.role == 'Admin') {
      return createTest();
    }
    return homePage();
  }
}
