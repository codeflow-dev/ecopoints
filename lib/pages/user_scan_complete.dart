import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserScanCompletePage extends StatelessWidget {
  final String id;

  const UserScanCompletePage(this.id, {super.key});

  Future<int> updateTransaction() async {
    final data = (await FirebaseFirestore.instance
            .collection("provide_transactions")
            .doc(id)
            .get())
        .data()!;
    if (data["received"] == false) {
      final points = data["points"] as int;
      await FirebaseFirestore.instance
          .collection("provide_transactions")
          .doc(id)
          .set({'received': true}, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"points": FieldValue.increment(points)});
      return points;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: updateTransaction(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
          );
        }

        if (snapshot.hasData && snapshot.data! == 0) {
          return Scaffold(
            appBar: AppBar(title: Text("Points are already claimed")),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data!;
          return Scaffold(
            appBar: AppBar(title: Text("Points added successfully")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, size: 40),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "$data points are added to your account.",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
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
