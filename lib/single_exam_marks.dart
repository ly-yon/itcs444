import 'package:flutter/material.dart';
import "firebase.dart";
import 'respond_details.dart';

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

class Single_Mark extends StatefulWidget {
  Map<String, dynamic> data;
  Single_Mark({Key? key, required this.data}) : super(key: key);

  @override
  State<Single_Mark> createState() => _Single_MarkState();
}

class _Single_MarkState extends State<Single_Mark> {
  @override
  Widget build(BuildContext context) {
    int total = calculateTotalGrades(widget.data["questions"]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe9edf6),
        foregroundColor: Colors.black,
        title: Text("Response PAGE"),
      ),
      backgroundColor: Color(0xff2a364e),
      body: Container(
        padding: EdgeInsets.all(3),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                widget.data["title"],
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 4),
              alignment: Alignment.centerLeft,
              // foregroundDecoration: BoxDecoration(color: Colors.white),
              child: Text("Responders Marks",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            StreamBuilder<dynamic>(
                stream: getResponses(widget.data["EID"]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No Responses Yet!",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }
                  List responses = snapshot.data!;
                  return Flexible(
                      child: ListView.builder(
                          itemCount: responses.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 7.0),
                                elevation: 3,
                                child: FutureBuilder(
                                  future: getUserbyID(responses[index]["uid"]),
                                  builder: (context, snapshot) {
                                    final grades = gradasAndQuestion(
                                        responses[index]["answers"], total);
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Center(
                                        child: Text(
                                          "Error Retrieving User Data!",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      );
                                    }

                                    final userData = snapshot.data![0];
                                    return InkWell(
                                        splashColor:
                                            Color.fromARGB(96, 42, 54, 78),
                                        // Alert Dialog For Delete / Edit / Cancel
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => details(
                                                      userData: userData,
                                                      Questions: widget.data,
                                                      userAnswers:
                                                          responses[index])));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical:
                                                  3.0), // Added vertical padding
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.edit_note,
                                              size: 32,
                                              color: levelColor[
                                                  widget.data["level"]],
                                            ),
                                            title: Text(
                                              "${snapshot.data![0]["name"] ?? ""}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    '${grades["totalGradedQuestions"]}/${widget.data["questions"].length} Question Graded'),
                                                const SizedBox(
                                                    height:
                                                        4), // Added space between subtitle and attempts
                                              ],
                                            ),
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 3.0,
                                                      horizontal: 6),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                      color: grades[
                                                          "resultColor"]),
                                                  child: Text(
                                                    '${grades["earnedGrades"]}/$total',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Grade',
                                                  style: TextStyle(
                                                      color:
                                                          grades["resultColor"],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
                                  },
                                ));
                          }));
                }),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
