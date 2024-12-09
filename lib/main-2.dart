import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'firebase.dart';
import 'exam_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeApp();
//   runApp(const QuizApp());
// }

// class QuizApp extends StatelessWidget {
//   const QuizApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const HomePage(),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedLevel = 'All';
  String selectedStatus = 'All';
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2F48),
        leading: const Icon(Icons.menu),
        title: const Text(
          "HOME PAGE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 246, 246, 245),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset('assets/quiz_logo.png', width: 50),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF2C2F48),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Enter the test name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (_) {
                        setState(() {}); // Trigger filtering
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('exams').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('No exams available.'));
                }

                final exams = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return {
                    'id': doc.id,
                    'name': data['title'] ?? 'Unknown',
                    'questions': data['q_shuffle']
                        ? 'Shuffled Questions'
                        : 'Standard Questions',
                    'dueDate':
                        data['due_date']?.toDate().toString() ?? 'No due date',
                    'author': data['uid'] ?? 'Unknown Author',
                    'level': data['level'] ?? 'Unknown',
                    'time': '${data['duration'] ?? 0} minutes',
                    'attempts': data['attempts'] ?? 0,
                    'status':
                        (data['attempts'] ?? 0) > 0 ? 'Available' : 'Private',
                  };
                }).toList();

                return ListView.builder(
                  itemCount: exams.length,
                  itemBuilder: (context, index) {
                    final exam = exams[index];
                    return GestureDetector(
                      onTap: () {
                        if (exam['attempts'] == 0) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('No Remaining Attempts'),
                              content: const Text(
                                  'You have used all the attempts for this quiz.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ExamPage(examId: exam['id']),
                            ),
                          );
                        }
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        elevation: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ListTile(
                            leading: Icon(
                              Icons.edit_note,
                              size: 40,
                              color: exam['status'] == 'Private'
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            title: Text(
                              exam['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(exam['questions']),
                                Text('Due: ${exam['dueDate']}'),
                                const SizedBox(height: 4),
                                Text(
                                  '${exam['attempts']} Attempts Left',
                                  style: TextStyle(
                                    color: exam['status'] == 'Private'
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.timer,
                                  color: exam['status'] == 'Private'
                                      ? Colors.red
                                      : Colors.green,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  exam['time'],
                                  style: TextStyle(
                                    color: exam['status'] == 'Private'
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
