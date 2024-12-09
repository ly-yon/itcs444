import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import "firebase.dart";
import 'home_page_admin.dart';

final String UID = "CtAeNRV9MNPlvN956p8rj4Vkc4I3";

class Option_Question_data {
  String type;
  String question = "";
  int? Marks = 0;
  List options = [
    "+ Add Your Option 1",
    "+ Add Your Option 2",
  ];
  String Answer = "";
  bool shuffle = false;
  bool error = false;
  Option_Question_data(this.type);
}

class Question_data {
  String type;
  String question = "";
  int? Marks = 0;
  bool error = false;
  Question_data(this.type);
}

List question_to_json(List questions) {
  List res = [];
  questions.forEach((element) {
    switch (element.type) {
      case "t_f_question":
      case "mcq_question":
        return res.add({
          "q_type": element.type,
          "q_name": element.question,
          "marks": element.Marks,
          "options": element.options,
          "answer": element.Answer,
          "shuffle": element.shuffle
        });
      default:
        return res.add({
          "q_type": element.type,
          "q_name": element.question,
          "marks": element.Marks,
        });
    }
  });
  return res;
}

List json_to_question(List questions) {
  List res = [];
  for (var i = 0; i < questions.length; i++) {
    switch (questions[i]["q_type"]) {
      case "t_f_question":
        {
          res.add(Option_Question_data("t_f_question"));
          res[res.length - 1].Marks = questions[i]["marks"];
          res[res.length - 1].options = questions[i]["options"];
          res[res.length - 1].Answer = questions[i]["answer"];
          res[res.length - 1].question = questions[i]["q_name"];
          res[res.length - 1].error = false;
          res[res.length - 1].shuffle = questions[i]["shuffle"];
          break;
        }
      case "mcq_question":
        {
          res.add(Option_Question_data("mcq_question"));
          res[res.length - 1].Marks = questions[i]["marks"];
          res[res.length - 1].options = questions[i]["options"];
          res[res.length - 1].Answer = questions[i]["answer"];
          res[res.length - 1].question = questions[i]["q_name"];
          res[res.length - 1].error = false;
          res[res.length - 1].shuffle = questions[i]["shuffle"];
          break;
        }
      case "essay_question":
        {
          res.add(Question_data("essay_question"));
          res[res.length - 1].Marks = questions[i]["marks"];
          res[res.length - 1].question = questions[i]["q_name"];
          res[res.length - 1].error = false;
          break;
        }
      case "short_question":
        {
          res.add(Question_data("short_question"));
          res[res.length - 1].Marks = questions[i]["marks"];
          res[res.length - 1].question = questions[i]["q_name"];
          res[res.length - 1].error = false;
          break;
        }
      default:
        {
          return [];
        }
    }
  }
  return res;
}

class AddExam extends StatefulWidget {
  Map<String, dynamic>? data;
  AddExam({Key? key, this.data}) : super(key: key);

  @override
  State<AddExam> createState() => _AddExamState();
}

class _AddExamState extends State<AddExam> {
  final Map<String, num> minutesDuration = {
    "Minutes": 1,
    "Hours": 60,
    "Days": 24 * 60
  };
  List Questions = [];
  DateTime Date = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: Date,
        firstDate: Date,
        lastDate: DateTime(DateTime.now().year + 1));
    if (picked != null) {
      setState(() {
        Date = picked;
      });
    }
  }

  TextEditingController title = TextEditingController();
  TextEditingController duration = TextEditingController();
  final List<String> levelSelection = <String>[
    'Easy',
    'Medium',
    'Hard',
    'Extrodinary',
  ];
  final List<String> durationSelection = <String>[
    'Minutes',
    'Hours',
    'Days',
  ];
  final List<String> attemptsSelection = <String>[
    'No Limit',
    '1',
    '2',
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10"
  ];
  String selectedAttempt = "No Limit";
  String selectedLavel = "Easy";
  String selectedDuration = "Minutes";
  bool shuffleQuestion = false;
  bool new_mode = true;
  String? id;
  Color errorTitle = Colors.black;
  Color errorDuration = Colors.black;
  void removeQuestion(int index) {
    Questions.removeAt(index);
    setState(() {});
  }

  bool submission_validation(List questions, String title, String duration) {
    List<bool> valid = [];
    for (var i = 0; i < questions.length; i++) {
      Questions[i].error = validation(i);
      if (!Questions[i].error) {
        valid.add(true);
      } else {
        valid.add(false);
      }
    }
    if (title == "") {
      errorTitle = Colors.red;
    } else {
      errorTitle = Colors.black;
    }
    if (duration == "") {
      errorDuration = Colors.red;
    } else {
      errorDuration = Colors.black;
    }
    if (valid.every((element) => true) && title != "" && duration != "") {
      return true;
    } else
      return false;
  }

  bool validation(int index) {
    switch (Questions[index].type) {
      case "t_f_question":
      case "mcq_question":
        {
          if (Questions[index].question != "" &&
              Questions[index].Marks > 0 &&
              Questions[index].Answer != "")
            return false;
          else
            return true;
        }
      default:
        {
          if (Questions[index].question != "" && Questions[index].Marks > 0)
            return false;
          else
            return true;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data != null) {
      id = widget.data!["EID"];
      Questions = json_to_question(widget.data!["questions"]);
      selectedAttempt = widget.data!["attempts"].toString();
      selectedDuration = "Minutes";
      duration.text = widget.data!["duration"].toString();
      selectedLavel = widget.data!["level"];
      title.text = widget.data!["title"];
      Date = widget.data!["due_date"].toDate();
      shuffleQuestion = widget.data!["q_shuffle"];
      widget.data = null;
      new_mode = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Exam"),
        backgroundColor: Color(0xff2a364e),
      ),
      floatingActionButton: Builder(builder: (context) {
        return new_mode
            ? SpeedDial(
                //provide here features of your parent FAB
                label: Text("Add Question"),
                backgroundColor: Color.fromARGB(255, 190, 208, 250),
                foregroundColor: Colors.black,
                icon: Icons.add,
                activeIcon: Icons.close_rounded,
                // activeLabel: Text("Close"),
                overlayColor: Colors.black,
                // buttonSize: Size(100, 50),
                children: [
                    SpeedDialChild(
                      child: Icon(Icons.add_circle_outline_rounded),
                      label: 'True/False Question',
                      onTap: () {
                        if (Questions.length > 0) {
                          Questions[Questions.length - 1].error =
                              validation(Questions.length - 1);
                          if (!Questions[Questions.length - 1].error)
                            Questions.add(Option_Question_data("t_f_question"));
                          setState(() {});
                        } else {
                          Questions.add(Option_Question_data("t_f_question"));
                          setState(() {});
                        }
                      },
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.add_circle_outline_rounded),
                      label: 'MCQ Question',
                      onTap: () {
                        if (Questions.length > 0) {
                          Questions[Questions.length - 1].error =
                              validation(Questions.length - 1);
                          if (!Questions[Questions.length - 1].error)
                            Questions.add(Option_Question_data("mcq_question"));
                          setState(() {});
                        } else {
                          Questions.add(Option_Question_data("mcq_question"));
                          setState(() {});
                        }
                      },
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.add_circle_outline_rounded),
                      label: 'Essay Question',
                      onTap: () {
                        if (Questions.length > 0) {
                          Questions[Questions.length - 1].error =
                              validation(Questions.length - 1);
                          if (!Questions[Questions.length - 1].error)
                            Questions.add(Question_data("essay_question"));
                          setState(() {});
                        } else {
                          Questions.add(Question_data("essay_question"));
                          setState(() {});
                        }
                      },
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.add_circle_outline_rounded),
                      label: 'Short Question',
                      onTap: () {
                        if (Questions.length > 0) {
                          Questions[Questions.length - 1].error =
                              validation(Questions.length - 1);
                          if (!Questions[Questions.length - 1].error)
                            Questions.add(Question_data("short_question"));
                          setState(() {});
                        } else {
                          Questions.add(Question_data("short_question"));
                          setState(() {});
                        }
                      },
                    ),
                  ])
            : const SizedBox.shrink();
      }),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.all(8),
              child: TextField(
                controller: title,
                cursorColor: Color(0xff2a364e),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: errorTitle)),
                    labelText: 'Enter Exam Title',
                    labelStyle: TextStyle(color: errorTitle)),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              width: double.infinity / 2,
              child: Row(children: [
                Padding(padding: EdgeInsets.all(8), child: Text("Level:")),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedLavel,
                    items: levelSelection.map((e) {
                      return DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          selectedLavel = value;
                        }
                      });
                    },
                    isExpanded: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 80,
                  child: TextField(
                    controller: duration,
                    cursorColor: Color(0xff2a364e),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: errorDuration)),
                        labelText: 'Duration',
                        labelStyle: TextStyle(color: errorDuration)),
                  ),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedDuration,
                    items: durationSelection.map((e) {
                      return DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          selectedDuration = value;
                        }
                      });
                    },
                    isExpanded: true,
                  ),
                )
              ]),
            ),
            Container(
              margin: EdgeInsets.all(8),
              width: double.infinity / 2,
              child: Row(children: [
                Padding(padding: EdgeInsets.all(8), child: Text("Due Date :")),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Text(
                      Date.toString(),
                      style: const TextStyle(color: Color(0xff2a364e)),
                    ),
                  ),
                )),
                Padding(padding: EdgeInsets.all(8), child: Text("Attempts :")),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedAttempt,
                    items: attemptsSelection.map((e) {
                      return DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          selectedAttempt = value;
                        }
                      });
                    },
                    isExpanded: true,
                  ),
                )
              ]),
            ),
            ListView.builder(
                itemCount: Questions.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  switch (Questions[index].type) {
                    case "t_f_question":
                      return t_f_question(
                        index: index,
                        removeQuestion: removeQuestion,
                        new_mode: new_mode,
                        data: Questions[index],
                      );
                    case "mcq_question":
                      return mcq_question(
                        index: index,
                        removeQuestion: removeQuestion,
                        new_mode: new_mode,
                        data: Questions[index],
                      );
                    default:
                      return General_question(
                        index: index,
                        removeQuestion: removeQuestion,
                        new_mode: new_mode,
                        data: Questions[index],
                      );
                  }
                }),
            Builder(
              builder: (context) {
                if (Questions.length > 1) {
                  return Container(
                      margin: EdgeInsets.all(6),
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      height: 25,
                      child: Row(
                        children: [
                          Checkbox(
                              value: shuffleQuestion,
                              activeColor: Colors.blue,
                              onChanged: (v) {
                                shuffleQuestion = v!;
                                setState(() {});
                              }),
                          Text("Suffle Questions"),
                        ],
                      ));
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            Builder(
              builder: (context) {
                if (Questions.isNotEmpty) {
                  return Container(
                    margin: EdgeInsets.all(6),
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          if (submission_validation(
                              Questions, title.text, duration.text)) {
                            addExam({
                              "UID": UID,
                              "attempts": int.parse(selectedAttempt),
                              "due_date": Date,
                              "duration": (int.parse(duration.text) *
                                  minutesDuration[selectedDuration]!),
                              "level": selectedLavel,
                              "questions": question_to_json(Questions),
                              "title": title.text,
                              "q_shuffle": shuffleQuestion
                            }, id);
                            Navigator.pop(context);
                          }
                          setState(() {});
                        },
                        child: Text("Publish Exam")),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}

class t_f_question extends StatefulWidget {
  final int index;
  final Function removeQuestion;
  final bool new_mode;
  Option_Question_data data;
  t_f_question(
      {Key? key,
      required this.index,
      required this.removeQuestion,
      required this.new_mode,
      required this.data})
      : super(key: key);

  @override
  State<t_f_question> createState() => _t_f_questionState();
}

class _t_f_questionState extends State<t_f_question> {
  // bool? answer;

  @override
  Widget build(BuildContext context) {
    widget.data.options = ["True", "False"];
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(4),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: widget.data.error ? Colors.red : Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text("Question ${widget.index + 1}")),
                  Builder(builder: (context) {
                    return widget.new_mode
                        ? TextButton.icon(
                            onPressed: () {
                              widget.removeQuestion(widget.index);
                            },
                            icon: Icon(Icons.delete_outline_rounded),
                            label: Text("Remove"))
                        : const SizedBox.shrink();
                  })
                ],
              ),
              Container(
                margin: EdgeInsets.all(8),
                child: TextField(
                  controller: TextEditingController()
                    ..text = widget.data.question,
                  onChanged: (value) => widget.data.question = value,
                  cursorColor: Color(0xff2a364e),
                  decoration: const InputDecoration(
                      disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'Enter Question Here',
                      labelStyle: TextStyle(color: Color(0xff2a364e))),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    style: const ButtonStyle(
                        // backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                        alignment: Alignment.centerLeft,
                        foregroundColor:
                            MaterialStatePropertyAll(Colors.black)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Number Of Marks Can Earned"),
                              content: TextField(
                                controller: TextEditingController()..text = "",
                                onChanged: (text) =>
                                    {widget.data.Marks = int.parse(text)},
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                cursorColor: Color(0xff2a364e),
                                decoration: const InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    labelText: 'Number of Marks',
                                    labelStyle:
                                        TextStyle(color: Color(0xff2a364e))),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
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
                    child: const Text("+ Add Marks"),
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Total: ${widget.data.Marks}",
                      style: TextStyle(fontWeight: FontWeight.bold),
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.centerRight,
                        child: Text(
                            "tip: Select the Correct Answer from the Below"),
                      ))
                    ],
                  )),
              ListTile(
                  title: const Text("True"),
                  leading: Radio<String>(
                    activeColor: Colors.blue,
                    value: "true",
                    groupValue: widget.data.Answer,
                    onChanged: ((e) {
                      if (e != null) {
                        widget.data.Answer = e;
                      }
                      setState(() {});
                    }),
                  )),
              ListTile(
                  title: const Text("False"),
                  leading: Radio<String>(
                    activeColor: Colors.blue,
                    value: "false",
                    groupValue: widget.data.Answer,
                    onChanged: ((e) {
                      if (e != null) {
                        widget.data.Answer = e;
                      }
                      setState(() {});
                    }),
                  )),
            ],
          ),
        ),
        Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10),
            child: widget.data.error
                ? Text(
                    "Error, Make Sure you added all the fields",
                    style: TextStyle(color: Colors.red),
                  )
                : null)
      ],
    );
  }
}

class mcq_question extends StatefulWidget {
  final int index;
  final Function removeQuestion;
  final bool new_mode;
  Option_Question_data data;
  mcq_question(
      {Key? key,
      required this.index,
      required this.removeQuestion,
      required this.new_mode,
      required this.data})
      : super(key: key);

  @override
  State<mcq_question> createState() => _mcq_questionState();
}

class _mcq_questionState extends State<mcq_question> {
  // int? answer;
  // bool shuffling = false;
  // List<String> answers = [
  //   "+ Add Your Option Here",
  //   "+ Add Your Option Here",
  // ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(4),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: widget.data.error ? Colors.red : Colors.black,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text("Question ${widget.index + 1}")),
                  Builder(builder: (context) {
                    return widget.new_mode
                        ? TextButton.icon(
                            onPressed: () {
                              widget.removeQuestion(widget.index);
                            },
                            icon: Icon(Icons.delete_outline_rounded),
                            label: Text("Remove"))
                        : const SizedBox.shrink();
                  })
                ],
              ),
              Container(
                margin: EdgeInsets.all(8),
                child: TextField(
                  controller: TextEditingController()
                    ..text = widget.data.question,
                  onChanged: (value) => widget.data.question = value,
                  cursorColor: Color(0xff2a364e),
                  decoration: const InputDecoration(
                      disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'Enter Question Here',
                      labelStyle: TextStyle(color: Color(0xff2a364e))),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    style: const ButtonStyle(
                        // backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                        alignment: Alignment.centerLeft,
                        foregroundColor:
                            MaterialStatePropertyAll(Colors.black)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Number Of Marks Can Earned"),
                              content: TextField(
                                controller: TextEditingController()..text = "",
                                onChanged: (value) =>
                                    widget.data.Marks = int.parse(value),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                cursorColor: Color(0xff2a364e),
                                decoration: const InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    labelText: 'Number of Marks',
                                    labelStyle:
                                        TextStyle(color: Color(0xff2a364e))),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
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
                    child: const Text("+ Add Marks"),
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Total: ${widget.data.Marks}",
                      style: TextStyle(fontWeight: FontWeight.bold),
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.centerRight,
                        child: Text(
                            "tip: Select the Correct Answer from the Below"),
                      ))
                    ],
                  )),
              ListView.builder(
                  itemCount: widget.data.options.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(widget.data.options[index]),
                      leading: Radio<String>(
                        activeColor: Colors.blue,
                        value: widget.data.options[index],
                        groupValue: widget.data.Answer,
                        onChanged: ((e) {
                          if (e != null) {
                            widget.data.Answer = e;
                          }
                          setState(() {});
                        }),
                      ),
                      trailing: index > 1 && widget.new_mode
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            TextEditingController option =
                                                TextEditingController();
                                            return AlertDialog(
                                              title:
                                                  Text("Option ${index + 1}"),
                                              content: TextField(
                                                controller: option,
                                                cursorColor: Color(0xff2a364e),
                                                decoration: const InputDecoration(
                                                    disabledBorder:
                                                        UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                    labelText: 'Enter The Text',
                                                    labelStyle: TextStyle(
                                                        color:
                                                            Color(0xff2a364e))),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      if (option.text != "") {
                                                        widget.data.options[
                                                                index] =
                                                            option.text;
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
                                    icon: Icon(Icons.edit_document)),
                                IconButton(
                                    onPressed: () {
                                      widget.data.options.removeAt(index);
                                      setState(() {});
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            )
                          : IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      TextEditingController option =
                                          TextEditingController();
                                      return AlertDialog(
                                        title: Text("Option ${index + 1}"),
                                        content: TextField(
                                          controller: option,
                                          cursorColor: Color(0xff2a364e),
                                          decoration: const InputDecoration(
                                              disabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black)),
                                              labelText: 'Enter The Text',
                                              labelStyle: TextStyle(
                                                  color: Color(0xff2a364e))),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                if (option.text != "") {
                                                  widget.data.options[index] =
                                                      option.text;
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
                              icon: Icon(Icons.edit_document)),
                    );
                  }),
              Row(
                children: [
                  Checkbox(
                      value: widget.data.shuffle,
                      activeColor: Colors.blue,
                      onChanged: (v) {
                        widget.data.shuffle = v!;
                        setState(() {});
                      }),
                  Text("Suffle The Options"),
                  Expanded(
                      child: Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Builder(builder: (context) {
                            return widget.new_mode
                                ? TextButton.icon(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            TextEditingController option =
                                                TextEditingController();
                                            return AlertDialog(
                                              title: Text(
                                                  "Option ${widget.data.options.length + 1}"),
                                              content: TextField(
                                                controller: option,
                                                cursorColor: Color(0xff2a364e),
                                                decoration: const InputDecoration(
                                                    disabledBorder:
                                                        UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                    labelText: 'Enter The Text',
                                                    labelStyle: TextStyle(
                                                        color:
                                                            Color(0xff2a364e))),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      if (option.text != "") {
                                                        widget.data.options
                                                            .add(option.text);
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
                                    icon: Icon(Icons.add_box_outlined),
                                    label: Text("Add Option"))
                                : const SizedBox.shrink();
                          })))
                ],
              )
            ],
          ),
        ),
        Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10),
            child: widget.data.error
                ? Text(
                    "Error, Make Sure you added all the fields",
                    style: TextStyle(color: Colors.red),
                  )
                : null)
      ],
    );
  }
}

class General_question extends StatefulWidget {
  final int index;
  final Function removeQuestion;
  final bool new_mode;
  Question_data data;
  General_question(
      {Key? key,
      required this.index,
      required this.removeQuestion,
      required this.new_mode,
      required this.data})
      : super(key: key);

  @override
  State<General_question> createState() => _General_questionState();
}

class _General_questionState extends State<General_question> {
  TextEditingController question = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(4),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: widget.data.error ? Colors.red : Colors.black,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text("Question ${widget.index + 1}")),
                  Builder(builder: (context) {
                    return widget.new_mode
                        ? TextButton.icon(
                            onPressed: () {
                              widget.removeQuestion(widget.index);
                            },
                            icon: Icon(Icons.delete_outline_rounded),
                            label: Text("Remove"))
                        : const SizedBox.shrink();
                  })
                ],
              ),
              Container(
                margin: EdgeInsets.all(8),
                child: TextField(
                  controller: TextEditingController()
                    ..text = widget.data.question,
                  onChanged: (value) => widget.data.question = value,
                  cursorColor: Color(0xff2a364e),
                  decoration: const InputDecoration(
                      disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'Enter Question Here',
                      labelStyle: TextStyle(color: Color(0xff2a364e))),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    style: const ButtonStyle(
                        // backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                        alignment: Alignment.centerLeft,
                        foregroundColor:
                            MaterialStatePropertyAll(Colors.black)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Number Of Marks Can Earned"),
                              content: TextField(
                                controller: TextEditingController()..text = "",
                                onChanged: (text) =>
                                    {widget.data.Marks = int.parse(text)},
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                cursorColor: Color(0xff2a364e),
                                decoration: const InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    labelText: 'Number of Marks',
                                    labelStyle:
                                        TextStyle(color: Color(0xff2a364e))),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
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
                    child: const Text("+ Add Marks"),
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Total: ${widget.data.Marks}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ))
                ],
              )
            ],
          ),
        ),
        Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10),
            child: widget.data.error
                ? Text(
                    "Error, Make Sure you added all the fields",
                    style: TextStyle(color: Colors.red),
                  )
                : null)
      ],
    );
  }
}
