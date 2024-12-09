import 'package:flutter/material.dart';
import 'registerSelectionPage.dart';

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF2A364E),
        body: Card(
            margin: EdgeInsets.all(28),
            color: Color(0xFF2A364E),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      // Left margin
                      top: 20, // Top margin
                      right: 260 // Right margin
                      // Bottom margin
                      ), // Set margin for all sides
                  // Set padding for all sides
                  width: 100, // Set width of the container
                  height: 80, // Set height of the container
                  child: Image(
                    image: AssetImage("assets/logo.png"),
                    // width: 30, // Image width inside the container
                    // height: 20, // Image height inside the container
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 300,
                ),
                Card(
                  margin: EdgeInsets.only(
                    left: 10, // Left margin
                    // Top margin
                    right: 130, // Right margin
                    // Bottom margin
                  ),
                  color: Color(0xFF2A364E),
                  child: Text(
                    'Automate your exams, elevate your results.',
                    style: TextStyle(
                        fontSize: 35,
                        height: 1,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Card(
                    margin: EdgeInsets.only(
                      right: 65, // Right margin
                    ),
                    color: Color(0xFF2A364E),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => registerSelectionPage()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.white,
                          width: 2, // Border color and width
                        ),
                        alignment: Alignment.centerLeft,
                        minimumSize: Size(300, 50), // Vertical space increased
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize
                            .min, // Ensures button adjusts to content
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(fontSize: 28, color: Colors.white),
                          ),
                          SizedBox(width: 70), // Space between icon and text
                          Icon(
                              Icons
                                  .arrow_forward, // Change to your desired icon
                              color: Colors.white,
                              size: 30),
                        ],
                      ),
                    )),
              ],
            )));
  }
}