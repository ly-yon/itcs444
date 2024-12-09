import 'package:flutter/material.dart';
import 'package:flutter_application_project/authProvider.dart';
import 'package:flutter_application_project/createTest.dart';
import 'package:flutter_application_project/homePage.dart';
import 'package:flutter_application_project/loginPage.dart';

import 'package:flutter_application_project/marks.dart';
import 'package:flutter_application_project/registerSelectionPage.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
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
    } else if (authProvider.role == 'Student') {
      return marks();
    }

    return homePage(); // Fallback in case of missing role
  }
}
