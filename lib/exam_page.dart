import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamPage extends StatefulWidget {
  final String examId;

  const ExamPage({Key? key, required this.examId}) : super(key: key);

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  Map<String, dynamic>? examData;
  Map<int, dynamic> answers = {};
  late Timer timer;
  Duration timeRemaining = const Duration();

  @override
  void initState() {
    super.initState();
    fetchExamData();
  }

  Future<void> fetchExamData() async {
    final doc = await FirebaseFirestore.instance.collection('exams').doc(widget.examId).get();
    final data = doc.data();
    if (data != null) {
      setState(() {
        examData = data;
        timeRemaining = Duration(minutes: data['duration'] ?? 0);

        // Shuffle questions while preserving question_id
        final questions = List<dynamic>.from(data['questions'] ?? []);
        questions.shuffle(); // Shuffle the questions
        examData!['questions'] = questions;
      });
      startTimer();
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.inSeconds > 0) {
        setState(() {
          timeRemaining -= const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        onSubmit(feedback: 'Time is up!');
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> onSubmit({String feedback = 'Submitted successfully!'}) async {
    if (examData == null) return;

    try {
      // Prepare the response data
      String responseId = FirebaseFirestore.instance.collection('responses').doc().id; // Generate a unique ID
      Map<String, dynamic> response = {
        'RID': responseId,
        'answers': [],
        'attempts_taken': (examData?['attempts'] ?? 1),
        'started_date': DateTime.now(),
        'uid': 'student_user_id', // Replace with actual user ID
        'feedback': feedback,
      };

      // Calculate marks and collect answers
      final questions = examData!['questions'] as List<dynamic>;
      int totalMarks = 0;

      for (final question in questions) {
        final questionId = question['question_id']; // Get question_id
        final questionType = question['q_type'];
        final correctAnswer = question['answer'];
        final userAnswer = answers[questionId];

        int marks = 0;

        if (questionType == 'mcq_question' || questionType == 't_f_question') {
          if (userAnswer != null && correctAnswer != null) {
            marks = (userAnswer.toString().trim() == correctAnswer.toString().trim()) ? question['marks'] : 0;
          }
          totalMarks += marks;
        } else if (questionType == 'short_question' || questionType == 'essay_question') {
          marks = 0; // Keep marks null for open-ended answers
        }

        response['answers'].add({
          'question_id': questionId, // Ensure the correct question_id is submitted
          'answer': userAnswer ?? 'No Answer',
          'mark': marks,
        });
      }

      response['total_marks'] = totalMarks;

      // Submit the response to Firestore
      await FirebaseFirestore.instance
          .collection('exams')
          .doc(widget.examId)
          .collection('responses')
          .doc(responseId)
          .set(response);

      // Decrement attempts
      final remainingAttempts = (examData?['attempts'] ?? 1) - 1;
      await FirebaseFirestore.instance.collection('exams').doc(widget.examId).update({'attempts': remainingAttempts});

      // Show success message and navigate back
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(feedback)),
        );
        Navigator.pop(context); // Go back to the main page
      }
    } catch (error) {
      print("Error during submission: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: $error')),
      );
    }
  }

  String formatTime(Duration duration) {
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${duration.inHours}:${minutes}:${seconds}';
  }

  @override
  Widget build(BuildContext context) {
    if (examData == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final questions = examData!['questions'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(examData!['title'] ?? 'Exam'),
        backgroundColor: const Color(0xFF2C2F48),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exam Progress Card
            Card(
              color: Colors.grey[200],
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time Remaining: ${formatTime(timeRemaining)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: timeRemaining.inSeconds / (60 * (examData!['duration'] ?? 1)),
                      color: Colors.purple,
                      backgroundColor: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Attempts Left: ${examData!['attempts']}',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Questions List
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final questionType = question['q_type'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                    color: Colors.grey[100],
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Question Text
                          Text(
                            '${index + 1}. ${question['q_name']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          // Display Marks
                          Text(
                            'Marks: ${question['marks'] ?? 0}',
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          // Question Type Logic
                          if (questionType == 'mcq_question') ...[
                            Column(
                              children: (question['options'] as List<dynamic>)
                                  .map(
                                    (option) => RadioListTile(
                                      title: Text(option),
                                      value: option,
                                      groupValue: answers[question['question_id']],
                                      onChanged: (value) {
                                        setState(() {
                                          answers[question['question_id']] = value;
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ] else if (questionType == 't_f_question') ...[
                            Column(
                              children: ['True', 'False']
                                  .map(
                                    (option) => RadioListTile(
                                      title: Text(option),
                                      value: option,
                                      groupValue: answers[question['question_id']],
                                      onChanged: (value) {
                                        setState(() {
                                          answers[question['question_id']] = value;
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ] else if (questionType == 'short_question' || questionType == 'essay_question') ...[
                            TextFormField(
                              maxLines: questionType == 'essay_question' ? 5 : 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Type your answer here...',
                              ),
                              onChanged: (value) {
                                answers[question['question_id']] = value;
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C2F48),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                                        fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
