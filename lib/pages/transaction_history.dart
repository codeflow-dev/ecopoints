import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopoints/color_schemes.g.dart';
import 'package:ecopoints/pages/agent_calculate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  Future<QuerySnapshot<Map<String, dynamic>>> getResult() async {
    final orders = await FirebaseFirestore.instance
        .collection("orders")
        .where('agent', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    return orders;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getResult(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
          );
        }

        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text("No orders to approve")),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data!.docs.map((e) => e.data()).toList();
          final orders = data.map((e) {
            var mp = Map.from(e);
            mp.remove("agent");
            mp.remove("approved");
            mp.remove("user");
            return mp;
          }).toList();
          return Scaffold(
            appBar: AppBar(title: Text("History")),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    for (var i = 0; i < orders.length; i++)
                      Card(
                        elevation: 5,
                        child: ListTile(
                          leading: Icon(Icons.inventory),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Table(
                                children: [
                                  for (var item in orders[i].entries)
                                    TableRow(
                                      children: [
                                        TableTextCell(
                                          item.key.toUpperCase()[0] +
                                              item.key.substring(1),
                                        ),
                                        TableTextCell(item.value.toString()),
                                      ],
                                    ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: darkGreenColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    data[i]["approved"] as bool
                                        ? "Approved"
                                        : "Not Approved",
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text("Loading...")),
        );
      },
    );
    /*
    return Scaffold(
      appBar: AppBar(title: Text("History")),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(icon: Icon(Icons.shop), label: "Orders"),
          NavigationDestination(icon: Icon(Icons.redeem), label: "Redeems"),
        ],
      ),
      body: <Widget>[
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.inventory),
                    title: Text("Tareque Md Hanif"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Table(
                          children: [
                            TableRow(
                              children: [
                                TableTextCell("ss"),
                                TableTextCell("tt"),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: darkGreenColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Approved",
                              textAlign: TextAlign.left,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Placeholder(),
      ][currentPageIndex],
    );
    */
  }
}
