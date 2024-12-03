import 'package:flutter/material.dart';
import 'exam_page.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedLevel = 'All';
  String selectedStatus = 'All';
  TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> allTests = [
    {
      'name': 'MATH101 Midterm 1',
      'questions': 10,
      'dueDate': '29-11-2024',
      'author': 'Amr Abdulmawla',
      'level': 'Beginner',
      'time': '1:00:00',
      'attempts': 3,
      'status': 'Available',
    },
    {
      'name': 'MATH102 Midterm 2',
      'questions': 15,
      'dueDate': '30-11-2024',
      'author': 'Sara Ali',
      'level': 'Intermediate',
      'time': '1:30:00',
      'attempts': 2,
      'status': 'Private',
    },
  ];

  List<Map<String, dynamic>> filteredTests = [];

  @override
  void initState() {
    super.initState();
    filteredTests = allTests;
    searchController.addListener(() {
      filterTests();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterTests() {
    setState(() {
      filteredTests = allTests.where((test) {
        final searchInput = searchController.text.toLowerCase();
        final matchesSearch = test['name'].toLowerCase().contains(searchInput);
        final levelMatches = selectedLevel == 'All' || test['level'] == selectedLevel;
        final statusMatches = selectedStatus == 'All' || test['status'] == selectedStatus;
        return matchesSearch && levelMatches && statusMatches;
      }).toList();
    });
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedLevel,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: 'Beginner', child: Text('Beginner')),
                    DropdownMenuItem(value: 'Intermediate', child: Text('Intermediate')),
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        selectedLevel = value;
                      });
                      filterTests();
                    }
                  },
                ),
                DropdownButton<String>(
                  value: selectedStatus,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: 'Available', child: Text('Available')),
                    DropdownMenuItem(value: 'Private', child: Text('Private')),
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        selectedStatus = value;
                      });
                      filterTests();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTests.length,
              itemBuilder: (context, index) {
                final test = filteredTests[index];
                return GestureDetector(
                  onTap: () {
                    if (test['attempts'] == 0) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('No Remaining Attempts'),
                          content: const Text('You have used all the attempts for this quiz.'),
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
                    } else if (test['status'] == 'Private') {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Quiz is Private'),
                          content: const Text('This quiz is currently private and cannot be accessed.'),
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
                          builder: (context) => ExamPage(
                            quizDetails: test,
                            onUpdateAttempts: (testName, remainingAttempts) {
                              setState(() {
                                final testToUpdate = allTests.firstWhere((t) => t['name'] == testName);
                                testToUpdate['attempts'] = remainingAttempts;
                                if (remainingAttempts == 0) {
                                  testToUpdate['status'] = 'Private';
                                }
                              });
                            },
                          ),
                        ),
                                              );
                    }
                  },
                  child: Card(
  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  elevation: 3,
  child: Container(
    padding: const EdgeInsets.symmetric(vertical: 16.0), // Added vertical padding
    child: ListTile(
      leading: Icon(
        Icons.edit_note,
        size: 40,
        color: test['status'] == 'Private' ? Colors.red : Colors.green,
      ),
      title: Text(
        test['name'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${test['questions']} Questions'),
          Text('Due: ${test['dueDate']}'),
          const SizedBox(height: 4), // Added space between subtitle and attempts
          Text(
            '${test['attempts']} Attempts Left',
            style: TextStyle(
              color: test['status'] == 'Private' ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer,
            color: test['status'] == 'Private' ? Colors.red : Colors.green,
          ),
          const SizedBox(height: 4),
          Text(
            '${test['time']}',
            style: TextStyle(
              color: test['status'] == 'Private' ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    ),
  ),
),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}