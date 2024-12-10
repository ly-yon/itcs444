import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase.dart';
import 'exam_page.dart';
import "student_result_view.dart";
import "authProvider.dart";
import "package:provider/provider.dart";
import "homePage.dart";

final Map<String, Color?> levelColor = {
  "Easy": Colors.green,
  "Medium": Colors.yellow[700],
  "Hard": const Color.fromARGB(255, 190, 0, 0)
};
int calculateTotalGrades(List questions) {
  int total = 0;
  questions.forEach((element) {
    total += element["marks"] as int;
  });
  return total;
}

Map<String, dynamic> gradasAndQuestion(List grades, int total) {
  int gradedQuestion = 0;
  int totlalEarned = 0;
  grades.forEach((element) {
    if (element["mark"] != null) {
      gradedQuestion++;
      totlalEarned += element["mark"] as int;
    }
  });
  Color? result;
  switch (totlalEarned / total * 100) {
    case (> 90):
      {
        result = Colors.green[700];
        break;
      }
    case (> 80):
      {
        result = Colors.green;
        break;
      }
    case (> 70):
      {
        result = Colors.yellow[700];
        break;
      }
    case (> 60):
      {
        result = Colors.orange;
        break;
      }
    default:
      {
        result = Colors.red;
        break;
      }
  }
  return {
    "totalGradedQuestions": gradedQuestion,
    "earnedGrades": totlalEarned,
    "resultColor": result
  };
}
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

class studentHome extends StatefulWidget {
  const studentHome({super.key});

  @override
  _studentHomeState createState() => _studentHomeState();
}

class _studentHomeState extends State<studentHome> {
  int currentPageIndex = 0;
  @override
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2F48),
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
            child: Image.asset('assets/logo.png', width: 50),
          ),
        ],
      ),
      drawer: Drawer(
        width: 450,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xff2a364e)),
              child: Column(
                children: <Widget>[
                  Material(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      elevation: 10,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.person,
                          size: 40,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: FutureBuilder(
                      future: getUserbyID(authProvider.user?.uid ?? ""),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              "Error Retrieving User Data!",
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        }

                        return Text(
                          snapshot.data![0]["name"],
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade400))),
                child: Container(
                  height: 35.0,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Role : ${authProvider.role}",
                          style: TextStyle(fontSize: 17.0),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade400))),
                child: Container(
                  height: 35.0,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Email: ${authProvider.user?.email ?? "No Email"}",
                          style: TextStyle(fontSize: 17.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade400))),
                child: InkWell(
                  splashColor: Color(0xff2a364e),
                  onTap: () async {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const homePage()),
                      (Route route) => false,
                    );

                    return await authProvider.signOut();
                  },
                  child: const SizedBox(
                    height: 35.0,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.lock),
                        SizedBox(width: 20),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Logout",
                            style: TextStyle(fontSize: 17.0),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xffe9edf6),
        onDestinationSelected: (int index) {
          currentPageIndex = index;
          setState(() {});
        },
        indicatorColor: const Color(0xff2a364e),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.my_library_books_rounded,
              color: Colors.white,
            ),
            icon: Icon(Icons.my_library_books_rounded),
            label: 'Marks',
          ),
        ],
      ),
      body: ManagePages(
        index: currentPageIndex,
      ),
    );
  }
}

class ManagePages extends StatefulWidget {
  final int index;
  const ManagePages({Key? key, required this.index}) : super(key: key);

  @override
  State<ManagePages> createState() => _ManagePageaState();
}

class _ManagePageaState extends State<ManagePages> {
  @override
  Widget build(BuildContext context) {
    if (widget.index == 0) {
      return const studentHomePage();
    } else {
      return const studentMarks();
    }
  }
}

class studentHomePage extends StatefulWidget {
  const studentHomePage({super.key});

  @override
  State<studentHomePage> createState() => _studentHomePageState();
}

class _studentHomePageState extends State<studentHomePage> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            stream: FirebaseFirestore.instance.collection('exams').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('No exams available.'));
              }

              final exams = snapshot.data!.docs
                  .map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return {
                      'id': doc.id,
                      'name': data['title'] ?? 'Unknown',
                      'questions': data['q_shuffle']
                          ? 'Shuffled Questions'
                          : 'Standard Questions',
                      'dueDate': data['due_date']?.toDate().toString() ??
                          'No due date',
                      'author': data['uid'] ?? 'Unknown Author',
                      'level': data['level'] ?? 'Unknown',
                      'time': '${data['duration'] ?? 0} minutes',
                      'attempts': data['attempts'] ?? 0,
                      'status':
                          (data['attempts'] ?? 0) > 0 ? 'Available' : 'Private',
                    };
                  })
                  .where((exam) => exam['name']
                      .toString()
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()))
                  .toList();

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
                            builder: (context) => ExamPage(examId: exam['id']),
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}

class studentMarks extends StatefulWidget {
  const studentMarks({super.key});

  @override
  State<studentMarks> createState() => _studentMarksState();
}

class _studentMarksState extends State<studentMarks> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return StreamBuilder(
      stream: getStudentExamById(authProvider.user?.uid ?? ""),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              "No Exams Yet!",
              style: TextStyle(fontSize: 18),
            ),
          );
        }
        final List exams = snapshot.data!;
        return ListView.builder(
            itemCount: exams.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              int total = calculateTotalGrades(exams[index]["questions"]);
              return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 7.0),
                  elevation: 3,
                  child: FutureBuilder(
                    future: getStudentResponseById(
                        exams[index]["EID"], authProvider.user?.uid ?? ""),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            "Error Retrieving User Data!",
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }

                      final userAnswer = snapshot.data![0];
                      final grades =
                          gradasAndQuestion(userAnswer["answers"], total);
                      return InkWell(
                          splashColor: Color.fromARGB(96, 42, 54, 78),
                          // Alert Dialog For Delete / Edit / Cancel
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => student_result(
                                        Questions: exams[index],
                                        userAnswers: userAnswer)));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3.0), // Added vertical padding
                            child: ListTile(
                              leading: Icon(
                                Icons.edit_note,
                                size: 32,
                                color: levelColor[exams[index]["level"]],
                              ),
                              title: Text(
                                "${exams[index]["title"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${grades["totalGradedQuestions"]}/${exams[index]["questions"].length} Question Graded'),
                                  const SizedBox(
                                      height:
                                          4), // Added space between subtitle and attempts
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: grades["resultColor"]),
                                    child: Text(
                                      '${grades["earnedGrades"]}/$total',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Grade',
                                    style: TextStyle(
                                        color: grades["resultColor"],
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                  ));
            });
      },
    );
  }
}
