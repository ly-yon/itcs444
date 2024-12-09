import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase.dart';

int calculateTotalGrades(List questions) {
  int total = 0;
  questions.forEach((element) {
    total += element["marks"] as int;
  });
  return total;
}

Map<String, dynamic> gradasAndQuestion(List grades, int total) {
  int gradedQuestion = 0;
  int totalEarned = 0;
  grades.forEach((element) {
    if (element["mark"] != null) {
      gradedQuestion++;
      totalEarned += element["mark"] as int;
    }
  });
  Color? result;
  switch (totalEarned / total * 100) {
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
    "earnedGrades": totalEarned,
    "resultColor": result
  };
}

Color? textGrade(grade) {
  Color? result;
  switch (grade) {
    case null:
      {
        result = Colors.grey[500];
        break;
      }
    case 0:
      {
        result = Colors.red;
        break;
      }

    default:
      {
        result = Colors.green;
      }
  }
  return result;
}

class details extends StatefulWidget {
  Map userAnswers;
  Map userData;
  Map Questions;
  details(
      {Key? key,
      required this.userAnswers,
      required this.userData,
      required this.Questions})
      : super(key: key);

  @override
  State<details> createState() => _detailsState();
}

class _detailsState extends State<details> {
  bool readData = false;
  late Map userAnswers;
  late Map Questions;
  late Map userData;
  @override
  Widget build(BuildContext context) {
    update() {
      setState(() {});
    }

    if (!readData) {
      Questions = widget.Questions;
      userAnswers = widget.userAnswers;
      userData = widget.userData;
      readData = true;
    }
    int total = calculateTotalGrades(Questions["questions"]);
    Map grades = gradasAndQuestion(userAnswers["answers"], total);
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        backgroundColor: Color(0xff2a364e),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Text(
                    "Student Name:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      userData["name"],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Text(
                    "Student Email:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      userData["email"],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Text(
                    "Final Grade:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: grades["resultColor"]),
                      child: Text(
                        '${grades["earnedGrades"]}/$total',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xff2a364e))),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController feedback =
                              TextEditingController(
                                  text: widget.userAnswers["feedback"] != null
                                      ? widget.userAnswers["feedback"]
                                      : "");
                          return AlertDialog(
                            title: Text("ADD Feedback"),
                            content: TextField(
                              controller: feedback,
                              cursorColor: Color(0xff2a364e),
                              decoration: const InputDecoration(
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  labelText: 'Enter The Text',
                                  labelStyle:
                                      TextStyle(color: Color(0xff2a364e))),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    if (feedback.text != "") {
                                      widget.userAnswers["feedback"] =
                                          feedback.text;
                                    }
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Add")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"))
                            ],
                          );
                        });
                  },
                  child: Text(widget.userAnswers["feedback"] != null
                      ? "+ Edit Feedback"
                      : "+ Add Feedback")),
            ),
            ListView.builder(
                itemCount: Questions["questions"].length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  switch (Questions["questions"]
                          [userAnswers["answers"][index]["question_id"]]
                      ["q_type"]) {
                    case "t_f_question":
                    case "mcq_question":
                      return option_question(
                        index: index,
                        data: Questions["questions"]
                            [userAnswers["answers"][index]["question_id"]],
                        userAnswer: userAnswers["answers"][index],
                        update: update,
                      );
                    default:
                      return question(
                        index: index,
                        data: Questions["questions"]
                            [userAnswers["answers"][index]["question_id"]],
                        userAnswer: userAnswers["answers"][index],
                        update: update,
                      );
                  }
                }),
            Container(
              margin: EdgeInsets.all(6),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xff2a364e))),
                  onPressed: () {
                    updateGrades(widget.Questions["EID"],
                        widget.userAnswers["RID"], widget.userAnswers);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text("Apply Updates")),
            ),
          ],
        ),
      ),
    );
  }
}

class option_question extends StatefulWidget {
  final int index;
  Map data;
  Map userAnswer;
  Function update;
  option_question(
      {Key? key,
      required this.data,
      required this.index,
      required this.userAnswer,
      required this.update})
      : super(key: key);

  @override
  State<option_question> createState() => _option_questionState();
}

class _option_questionState extends State<option_question> {
  // bool? answer;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Color.fromARGB(96, 42, 54, 78),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              String textHandler =
                  widget.userAnswer["mark"].toString() == "null"
                      ? ""
                      : widget.userAnswer["mark"].toString();
              return AlertDialog(
                title: const Text("Number Of Marks Can Earned"),
                content: TextField(
                  controller: TextEditingController()
                    ..text = textHandler.toString(),
                  onChanged: (text) => {textHandler = text},
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  cursorColor: Color(0xff2a364e),
                  decoration: const InputDecoration(
                      disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'Edit Marks',
                      labelStyle: TextStyle(color: Color(0xff2a364e))),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (int.parse(textHandler) > widget.data["marks"]) {
                            widget.userAnswer["mark"] = widget.data["marks"];
                          } else {
                            widget.userAnswer["mark"] = int.parse(textHandler);
                          }
                          widget.update();
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Add")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"))
                ],
              );
            });
      },
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  "Question ${widget.index + 1}",
                ))
              ],
            ),
            Row(
              children: [
                Text(widget.data["q_name"],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(right: 10),
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: widget.userAnswer["mark"] == 0
                            ? Colors.red
                            : Colors.green),
                    child: Text(
                      "${widget.userAnswer["mark"]}/${widget.data["marks"]}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ))
              ],
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Text(
                      "Answer :",
                    )
                  ],
                )),
            ListView.builder(
              itemCount: widget.data["options"].length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(widget.data["options"][index]),
                    leading: Radio<String>(
                      activeColor: Colors.blue,
                      value: widget.data["options"][index],
                      groupValue: widget.userAnswer["answer"],
                      onChanged: ((e) {}),
                    ));
              },
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text("Correct Answer:"),
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(widget.data["answer"]),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class question extends StatefulWidget {
  final int index;
  Map data;
  Map userAnswer;
  Function update;
  question(
      {Key? key,
      required this.data,
      required this.index,
      required this.userAnswer,
      required this.update})
      : super(key: key);

  @override
  State<question> createState() => _questionState();
}

class _questionState extends State<question> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Color.fromARGB(96, 42, 54, 78),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                String textHandler =
                    widget.userAnswer["mark"].toString() == "null"
                        ? ""
                        : widget.userAnswer["mark"].toString();
                return AlertDialog(
                  title: const Text("Number Of Marks Can Earned"),
                  content: TextField(
                    controller: TextEditingController()
                      ..text = textHandler.toString(),
                    onChanged: (text) => {textHandler = text},
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    cursorColor: Color(0xff2a364e),
                    decoration: const InputDecoration(
                        disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelText: 'Edit Marks',
                        labelStyle: TextStyle(color: Color(0xff2a364e))),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            if (int.parse(textHandler) > widget.data["marks"]) {
                              widget.userAnswer["mark"] = widget.data["marks"];
                            } else {
                              widget.userAnswer["mark"] =
                                  int.parse(textHandler);
                            }
                            widget.update();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text("Add")),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"))
                  ],
                );
              });
        },
        child: Container(
          margin: EdgeInsets.all(4),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text("Question ${widget.index + 1}"),
                  )
                ],
              ),
              Container(
                  margin: EdgeInsets.all(8),
                  alignment: Alignment.bottomLeft,
                  child: Text(widget.data["q_name"],
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Row(
                children: [
                  Text("Answer : (Click To change the Marks!)"),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: textGrade(widget.userAnswer["mark"])),
                      child: Text(
                        "${widget.userAnswer["mark"] ?? "- "}/${widget.data["marks"]}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ))
                ],
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.userAnswer["answer"] ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ));
  }
}
