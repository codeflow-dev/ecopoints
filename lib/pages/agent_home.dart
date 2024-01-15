import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopoints/common.dart';
import 'package:ecopoints/pages/agent_calculate.dart';
import 'package:ecopoints/pages/agent_redeem_scan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AgentHomePage extends StatelessWidget {
  const AgentHomePage({super.key});

  Future getUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    var user =
        await FirebaseFirestore.instance.collection("agent").doc(uid).get();
    if (!user.exists) {
      final agent =
          (await FirebaseFirestore.instance.collection("user").doc(uid).get())
              .data()!;
      await FirebaseFirestore.instance.collection("agent").doc(uid).set(
        {
          "firstName": agent["firstName"],
          "lastName": agent["lastName"],
        },
        SetOptions(merge: true),
      );
      user =
          await FirebaseFirestore.instance.collection("agent").doc(uid).get();
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
          );
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(title: Text("Agent does not exist")),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(title: Text("Welcome, Agent ${data['firstName']}")),
            body: GridView.count(
              crossAxisCount: 2,
              children: [
                NavCard(
                  "Calculate Points",
                  Icons.calculate,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalculatePage(),
                      ),
                    );
                  },
                ),
                NavCard(
                  "Scan Redeem QR",
                  Icons.qr_code,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgentRedeemScanPage(),
                      ),
                    );
                  },
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
