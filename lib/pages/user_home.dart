import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopoints/pages/user_scan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatelessWidget {
  UserHomePage({super.key});

  final agent = FirebaseFirestore.instance
      .collection("user")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: agent,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
          );
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(title: Text("User does not exist")),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(title: Text("Welcome, ${data['firstName']}")),
            body: GridView.count(
              crossAxisCount: 2,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserScanPage(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code, size: 40),
                            SizedBox(height: 10),
                            Text(
                              "Scan QR Code",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text("Loading...")),
        );
      },
    );
  }
}
