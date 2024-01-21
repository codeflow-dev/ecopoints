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
                Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Image.asset(
                    "assets/ecopoints-reference.jpg",
                  ),
                ),
                Text(
                  "EcoPoints",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        Text("To provide or buy recyclables..."),
                        ElevatedButton(
                            onPressed: () =>
                                _navigateToSecondPage(context, "user"),
                            child: Text('Login as user')),
                      ],
                    ),
                    TableRow(children: [
                      Text("If you are an agent..."),
                      ElevatedButton(
                          onPressed: () =>
                              _navigateToSecondPage(context, "agent"),
                          child: Text('Login as agent')),
                    ])
                  ],
                ),
                Text(
                    "Please contact with admin to become an agent:\nPhone: 01310319767\nEmail: rifat@gmail.com"),
                SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
