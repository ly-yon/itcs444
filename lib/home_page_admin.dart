import 'package:flutter/material.dart';
import 'add_Exam.dart';
import 'single_exam_marks.dart';
import 'firebase.dart';

String uid = "CtAeNRV9MNPlvN956p8rj4Vkc4I3";
final Map<String, Color?> levelColor = {
  "Easy": Colors.green,
  "Medium": Colors.yellow[700],
  "Hard": const Color.fromARGB(255, 190, 0, 0)
};

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe9edf6),
        foregroundColor: Colors.black,
        title: Text("HOME PAGE"),
      ),
      drawer: Drawer(
        width: 450,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(color: Color(0xff2a364e)),
                child: Container(
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
                        child: Text(
                          'Ahmed Abdulla',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )),
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
                          "Role : Admin",
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
                          "Email: ahmedabdulla@gmail.com",
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
                child: Container(
                  height: 35.0,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "User ID: 553213443",
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
                child: InkWell(
                  splashColor: Color(0xff2a364e),
                  onTap: () {},
                  child: Container(
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
        backgroundColor: Color(0xffe9edf6),
        onDestinationSelected: (int index) {
          currentPageIndex = index;
          setState(() {});
        },
        indicatorColor: Color(0xff2a364e),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 190, 208, 250),
        foregroundColor: Colors.black,
        onPressed: () {
          currentPageIndex = -1;
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddExam()))
              .then((value) {
            currentPageIndex = 0;
            setState(() {});
          });
        },
        label: const Text('New Exam'),
        icon: const Icon(Icons.add),
      ),
      backgroundColor: Color(0xff2a364e),
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
      return const HomePage();
    } else {
      return const Marks();
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: getExamsByID(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height / 2.7,
                  child: Column(
                    children: [
                      Text(
                        "My Available Tests",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      Flexible(
                          child: Center(
                        child: Text(
                          "Create A New Exam!",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ))
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    // height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      children: [
                        Text(
                          "My Expired Tests",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        Flexible(
                            child: Center(
                          child: Text(
                            "Create A New Exam!",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ))
                      ],
                    ),
                  ),
                )
              ],
            );
          }
          List activeData = [];
          List expiredDate = [];
          snapshot.data!.forEach((element) {
            if (element["due_date"].seconds >
                DateTime.now().millisecondsSinceEpoch / 1000) {
              activeData.add(element);
            } else {
              expiredDate.add(element);
            }
          });

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height / 2.7,
                child: Column(
                  children: [
                    Text(
                      "My Available Tests",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    Flexible(
                        child: ListView.builder(
                            itemCount: activeData.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                elevation: 3,
                                child: InkWell(
                                  splashColor: Color.fromARGB(96, 42, 54, 78),
                                  // Alert Dialog For Delete / Edit / Cancel
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Edit or Delete the Exam?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    AddExam(
                                                                      data: activeData[
                                                                          index],
                                                                    )));
                                                  },
                                                  child: const Text("Edit")),
                                              TextButton(
                                                  onPressed: () {
                                                    deleteExam(activeData[index]
                                                        ["EID"]);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Delete"))
                                            ],
                                          );
                                        });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical:
                                            4.0), // Added vertical padding
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.edit_note,
                                        size: 32,
                                        color: levelColor[activeData[index]
                                            ["level"]],
                                      ),
                                      title: Text(
                                        activeData[index]["title"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${activeData[index]["questions"].length} Questions'),
                                          Text(
                                              'Due: ${activeData[index]["due_date"].toDate()}'),
                                          const SizedBox(
                                              height:
                                                  4), // Added space between subtitle and attempts
                                        ],
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.timer,
                                            color: Colors.green,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${activeData[index]["duration"]} Min',
                                            style: TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }))
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  // height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                    children: [
                      Text(
                        "My Expired Tests",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      Flexible(
                          child: ListView.builder(
                              itemCount: expiredDate.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  elevation: 3,
                                  child: InkWell(
                                    splashColor: Color.fromARGB(96, 42, 54, 78),
                                    // Alert Dialog For Delete / Edit / Cancel
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Edit or Delete the Exam?"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      AddExam(
                                                                        data: expiredDate[
                                                                            index],
                                                                      )));
                                                    },
                                                    child: const Text("Edit")),
                                                TextButton(
                                                    onPressed: () {
                                                      deleteExam(
                                                          expiredDate[index]
                                                              ["EID"]);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Delete"))
                                              ],
                                            );
                                          });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                              4.0), // Added vertical padding
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.edit_note,
                                          size: 32,
                                          color: levelColor[expiredDate[index]
                                              ["level"]],
                                        ),
                                        title: Text(
                                          expiredDate[index]["title"],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${expiredDate[index]["questions"].length} Questions'),
                                            Text(
                                                'Due: ${expiredDate[index]["due_date"].toDate()}'),
                                            const SizedBox(
                                                height:
                                                    4), // Added space between subtitle and attempts
                                          ],
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.timer,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Expired',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }))
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }
}

class Marks extends StatefulWidget {
  const Marks({super.key});

  @override
  State<Marks> createState() => _MarksState();
}

class _MarksState extends State<Marks> {
  final List<String> levelSelection = <String>[
    'All',
    'Easy',
    'Medium',
    'Hard',
  ];
  final List<String> statusSelection = <String>[
    'All',
    'Open',
    'Expired',
  ];
  String selectedLevel = "All";
  String selectedStatus = "All";
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: getExamsByID(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "Create A New Exam!",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }
          List Data = snapshot.data!;
          List filteredData = [];
          Data.forEach(
            (element) {
              if (selectedLevel == "All" && selectedStatus == "All") {
                filteredData.add(element);
              } else if (selectedLevel == "All") {
                String condition = element["due_date"].seconds <
                        DateTime.now().millisecondsSinceEpoch / 1000
                    ? "Expired"
                    : "Open";
                if (selectedStatus == condition) {
                  filteredData.add(element);
                }
              } else if (selectedStatus == "All") {
                if (selectedLevel == element["level"]) {
                  filteredData.add(element);
                }
              } else {
                String condition = element["due_date"].seconds <
                        DateTime.now().millisecondsSinceEpoch / 1000
                    ? "Expired"
                    : "Open";
                if (selectedLevel == element["level"] &&
                    condition == selectedStatus) {
                  filteredData.add(element);
                }
              }
            },
          );

          return Container(
            padding: EdgeInsets.all(3),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  // foregroundDecoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Text("Level: ", style: TextStyle(color: Colors.white)),
                      DropdownButton<String>(
                        value: selectedLevel,
                        dropdownColor: Color(0xff2a364e),
                        items: levelSelection.map((e) {
                          return DropdownMenuItem<String>(
                            value: e,
                            child: Text(
                              e,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            selectedLevel = value;
                          }
                          setState(() {});
                        },
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Status: ",
                              style: TextStyle(color: Colors.white)),
                          DropdownButton<String>(
                            value: selectedStatus,
                            dropdownColor: Color(0xff2a364e),
                            items: statusSelection.map((e) {
                              return DropdownMenuItem<String>(
                                value: e,
                                child: Text(
                                  e,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  selectedStatus = value;
                                }
                              });
                            },
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
                Flexible(
                    child: ListView.builder(
                        itemCount: filteredData.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            elevation: 3,
                            child: InkWell(
                              splashColor: Color.fromARGB(96, 42, 54, 78),
                              // Alert Dialog For Delete / Edit / Cancel
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Single_Mark(
                                              data: filteredData[index],
                                            )));
                              },

                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0), // Added vertical padding
                                child: ListTile(
                                  leading: Icon(
                                    Icons.edit_note,
                                    size: 32,
                                    color: levelColor[filteredData[index]
                                        ["level"]],
                                  ),
                                  title: Text(
                                    filteredData[index]["title"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${filteredData[index]["questions"].length} Questions'),
                                      Text(
                                          'Due: Due: ${filteredData[index]["due_date"].toDate()}'),
                                      const SizedBox(
                                          height:
                                              4), // Added space between subtitle and attempts
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(2.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            color: filteredData[index]
                                                            ["due_date"]
                                                        .seconds <
                                                    DateTime.now()
                                                            .millisecondsSinceEpoch /
                                                        1000
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                          child: FutureBuilder(
                                            future: getResponseCount(
                                                filteredData[index]["EID"]),
                                            builder: (context, snapshot) {
                                              return Text(
                                                snapshot.data?.toString() ==
                                                        null
                                                    ? "0"
                                                    : snapshot.data.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              );
                                            },
                                          )),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Responses',
                                        style: TextStyle(
                                            color: filteredData[index]
                                                            ["due_date"]
                                                        .seconds <
                                                    DateTime.now()
                                                            .millisecondsSinceEpoch /
                                                        1000
                                                ? Colors.red
                                                : Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          );
        });
  }
}
