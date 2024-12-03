import 'dart:async';
import 'package:flutter/material.dart';

class ExamPage extends StatefulWidget {
  final Map<String, dynamic> quizDetails;
  final Function(String testName, int remainingAttempts) onUpdateAttempts;

  const ExamPage({
    Key? key,
    required this.quizDetails,
    required this.onUpdateAttempts,
  }) : super(key: key);

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  String? selectedAnswerQ1;
  String? selectedAnswerQ2;
  String textAnswerQ3 = '';
  String? selectedAnswerQ4;
  Duration timeRemaining = const Duration(hours: 1);
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.inSeconds > 0) {
        setState(() {
          timeRemaining -= const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  bool areAllQuestionsAnswered() {
    return selectedAnswerQ1 != null &&
        selectedAnswerQ2 != null &&
        textAnswerQ3.isNotEmpty &&
        selectedAnswerQ4 != null;
  }

  void onSubmit() {
    if (widget.quizDetails['attempts'] > 0) {
      setState(() {
        widget.quizDetails['attempts'] -= 1;
      });

      widget.onUpdateAttempts(widget.quizDetails['name'], widget.quizDetails['attempts']); // Call the callback to update attempts in HomePage

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Submission Successful'),
          content: Text(
            'Answers Submitted!\n\n'
            'Q1: $selectedAnswerQ1\n'
            'Q2: $selectedAnswerQ2\n'
            'Q3: $textAnswerQ3\n'
            'Q4: $selectedAnswerQ4\n\n'
            'Attempts Left: ${widget.quizDetails['attempts']}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Redirect to the main page
              },
              child: const Text('OK'),
            ),
          ],
        ),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2F48),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.quizDetails['name'],
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: Colors.grey[200],
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.quizDetails['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text('By: ${widget.quizDetails['author']}'),
                      const SizedBox(height: 16),
                      const Text(
                        'Details & Information:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const Divider(),
                      Text('Time Remaining: ${formatTime(timeRemaining)}'),
                      Text('${widget.quizDetails['attempts']} Attempts Left'),
                      LinearProgressIndicator(
                        value: timeRemaining.inSeconds / (60 * 60),
                        color: Colors.purple,
                        backgroundColor: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Q1: Which club do you support?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  RadioListTile(
                    value: 'Real Madrid',
                    groupValue: selectedAnswerQ1,
                    onChanged: (value) {
                      setState(() {
                        selectedAnswerQ1 = value.toString();
                      });
                    },
                    title: const Text('Real Madrid'),
                  ),
                  RadioListTile(
                    value: 'Barcelona',
                    groupValue: selectedAnswerQ1,
                    onChanged: (value) {
                      setState(() {
                        selectedAnswerQ1 = value.toString();
                      });
                    },
                    title: const Text('Barcelona'),
                  ),
                ],
              ),
              const Divider(),
              const Text(
                'Q2: Is Flutter used for cross-platform development?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  RadioListTile(
                    value: 'True',
                    groupValue: selectedAnswerQ2,
                    onChanged: (value) {
                      setState(() {
                        selectedAnswerQ2 = value.toString();
                      });
                    },
                    title: const Text('True'),
                  ),
                  RadioListTile(
                    value: 'False',
                    groupValue: selectedAnswerQ2,
                    onChanged: (value) {
                      setState(() {
                        selectedAnswerQ2 = value.toString();
                      });
                    },
                    title: const Text('False'),
                  ),
                ],
              ),
              const Divider(),
              const Text(
                'Q3: Write a short note about your favorite programming language:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Type here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    textAnswerQ3 = value;
                  });
                },
              ),
              const Divider(),
              const Text(
                'Q4: Do you like programming?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  RadioListTile(
                    value: 'Yes',
                    groupValue: selectedAnswerQ4,
                    onChanged: (value) {
                      setState(() {
                        selectedAnswerQ4 = value.toString();
                      });
                    },
                    title: const Text('Yes'),
                  ),
                  RadioListTile(
                    value: 'No',
                    groupValue: selectedAnswerQ4,
                    onChanged: (value) {
                      setState(() {
                        selectedAnswerQ4 = value.toString();
                      });
                    },
                    title: const Text('No'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: areAllQuestionsAnswered() ? onSubmit : null,
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
            ],
          ),
        ),
      ),
    );
  }
}