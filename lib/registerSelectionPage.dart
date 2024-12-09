import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'signUpPage.dart';

class registerSelectionPage extends StatelessWidget {
  const registerSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF2A364E),
        appBar: AppBar(
          backgroundColor: Color(0xFFE9EDF6), // Hex color #e9edf6
        ),
        body: Center(
          child: Container(
              margin: EdgeInsets.only(), // Set margin for all sides
              padding: EdgeInsets.only(), // Set padding for all sides
              width: 350, // Set width of the container
              height: 800, // Set height of the container
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin: EdgeInsets.only(), // Set margin for all sides
                    padding: EdgeInsets.only(), // Set padding for all sides
                    width: double.infinity, // Set width of the container
                    height: 250, // Set height of the container
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 200,
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image(
                            image: AssetImage("assets/logo.png"),
                            // width: 30, // Image width inside the container
                            // height: 20, // Image height inside the container
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          width: 180,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "Automate your exams, elevate your results.",
                              textAlign:
                                  TextAlign.center, // Center-align the text
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                              softWrap:
                                  true, // Allow text to wrap to the next line
                              maxLines:
                                  2, // Limit the number of lines if needed
                              overflow: TextOverflow
                                  .ellipsis, // Add ellipsis if the text overflows
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),
                  SizedBox(
                    height: 110,
                  ),
                  Container(
                    margin: EdgeInsets
                        .only(), // Optional margin for the outer container
                    padding: EdgeInsets
                        .only(), // Optional padding for the outer container
                    width:
                        double.infinity, // Full width of the parent container
                    height: 250, // Set height of the outer container
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFDDD9D9),
                    ),
                    child: Center(
                      // Center the inner container
                      child: Container(
                        width: 290, // Adjusted width of the inner container
                        height: 200, // Adjusted height of the inner container
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // Center buttons inside
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => loginPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                    0xFF2A364E), // Button background color
                                foregroundColor: Colors.white,
                                // padding: EdgeInsets.symmetric(
                                //     horizontal: 30,
                                //     vertical: 15), // Button padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Rounded corners
                                ),
                                minimumSize: Size(290, 75),
                                elevation: 5, // Shadow effect
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => signUpPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                    0xFF3459A4), // Button background color
                                foregroundColor: Colors.white,
                                // padding: EdgeInsets.symmetric(
                                //     horizontal: 30,
                                //     vertical: 15), // Button padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Rounded corners
                                ),
                                minimumSize: Size(290, 75),
                                elevation: 5, // Shadow effect
                              ),
                              child: Text(
                                'SignUp',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
