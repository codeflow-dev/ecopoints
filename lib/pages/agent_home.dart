import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopoints/common.dart';
import 'package:ecopoints/pages/agent_calculate.dart';
import 'package:ecopoints/pages/agent_details.dart';
import 'package:ecopoints/pages/agent_order_approve_page.dart';
import 'package:ecopoints/pages/agent_price.dart';
import 'package:ecopoints/pages/agent_redeem_scan.dart';
import 'package:ecopoints/pages/agent_storage.dart';
import 'package:ecopoints/pages/register_page.dart';
import 'package:ecopoints/pages/transaction_history.dart';
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
            appBar: AppBar(
              title: Text(
                "Welcome, ${data.containsKey('admin') && data['admin'] == true ? "Admin" : "Agent"} ${data['firstName']}",
              ),
              leading: IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
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
                NavCard(
                  "Profile settings",
                  Icons.person,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgentDetailsPage(),
                      ),
                    );
                  },
                ),
                NavCard(
                  "Orders",
                  Icons.list_alt,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgentOrderApprovePage(),
                      ),
                    );
                  },
                ),
                if (data.containsKey('admin') && data['admin'] == true)
                  NavCard(
                    "Price manager",
                    Icons.money,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PriceManagementPage(),
                        ),
                      );
                    },
                  ),
                if (data.containsKey('admin') && data['admin'] == true)
                  NavCard(
                    "Add Agent",
                    Icons.add,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(
                            role: 'agent',
                          ),
                        ),
                      );
                    },
                  ),
                NavCard(
                  "Transaction History",
                  Icons.history,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionHistoryPage(),
                      ),
                    );
                  },
                ),
                NavCard(
                  "Storage Information",
                  Icons.storage,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoragePage(),
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
