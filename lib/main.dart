// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_project/AuthWrapper.dart';
import 'package:flutter_application_project/authProvider.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDaYezar8WW4kVYDut3kNTIiM-y_CNJhmk",
        authDomain: "itcs444-92e3f.firebaseapp.com",
        projectId: "itcs444-92e3f",
        //storageBucket: "itcs444-92e3f.firebasestorage.app",
        messagingSenderId: "293487894537",
        appId: "1:293487894537:web:cb807b4e0a669e098bd8d8"),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}
