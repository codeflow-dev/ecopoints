// ignore_for_file: unused_element, require_trailing_commas

import 'package:ecopoints/pages/login_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  void _navigateToSecondPage(context, String role) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(role: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 70, 20, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ecopoints",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () => _navigateToSecondPage(context, "user"),
                        child: Text(
                          'Provide or buy recyclable now!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () =>
                            _navigateToSecondPage(context, "agent"),
                        child: Text(
                          'Agent',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: ((context) => BuyerPage())));
                    //   },
                    //   child: Text("HI"),
                    // ),
                  ],
                ),
                // SizedBox(height: 20),
                // GestureDetector(
                //   onTap: () {},
                //   child: Container(
                //     height: 60,
                //     width: 200,
                //     decoration: BoxDecoration(
                //       color: Color.fromARGB(255, 146, 189, 154),
                //       borderRadius: BorderRadius.circular(30),
                //       boxShadow: [
                //         BoxShadow(
                //             color: Color.fromARGB(255, 4, 28, 57),
                //             spreadRadius: 1,
                //             blurRadius: 8,
                //             offset: Offset(4, 4)),
                //         BoxShadow(
                //             color: Color.fromARGB(255, 11, 63, 127),
                //             spreadRadius: 2,
                //             blurRadius: 8,
                //             offset: Offset(-4, -4))
                //       ],
                //     ),
                //     padding: EdgeInsets.all(10),
                //     child: Center(
                //       child: Text(
                //         'Login',
                //         style: TextStyle(
                //             fontSize: 30,
                //             fontWeight: FontWeight.bold,
                //             color: (Color.fromARGB(255, 18, 124, 132))),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/plant.png",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
