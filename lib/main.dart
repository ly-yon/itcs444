import 'package:flutter/material.dart';
import 'home_page_admin.dart';
import 'add_Exam.dart';
import 'single_exam_marks.dart';
import "respond_details.dart";
import 'firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Home());
  }
}
