import 'package:flutter/material.dart';
import 'package:itcs444/homePage.dart';
import 'home_page_admin.dart';
import 'add_Exam.dart';
import 'single_exam_marks.dart';
import "respond_details.dart";
import 'firebase.dart';
import 'package:provider/provider.dart';
import 'student_home_page.dart';
import 'authProvider.dart';
import 'exam_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthProvider()),
    ],
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: homePage());
  }
}
