import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopoints/common.dart';
import 'package:ecopoints/pages/agent_redeem_complete.dart';
import 'package:flutter/material.dart';

class AgentRedeemDataPage extends StatefulWidget {
  final String id;

  const AgentRedeemDataPage(this.id, {super.key});

  @override
  State<AgentRedeemDataPage> createState() => _AgentRedeemDataPageState();
}

class _AgentRedeemDataPageState extends State<AgentRedeemDataPage> {
  Future getRedeem() {
    final redeem =
        FirebaseFirestore.instance.collection("redeem").doc(widget.id).get();
    return redeem;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getRedeem(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
          );
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(title: Text("Invalid QR code")),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          Map items = data;
          bool received = data["received"];
          items.remove("received");
          return Scaffold(
            appBar: AppBar(title: Text("Redeem Item Details")),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                if (!received) {
                  showLoadingDialog(context);
                  await FirebaseFirestore.instance
                      .collection("redeem")
                      .doc(widget.id)
                      .update({"received": true});
                  if (mounted) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgentRedeemCompletePage(items),
                      ),
                    );
                  }
                } else {
                  showToast("Redeem transaction is already approved.");
                }
              },
              label: Text(received ? "Approved" : "Approve"),
              icon: Icon(Icons.check_circle),
            ),
            body: Column(
              children: [
                for (final item in items.entries)
                  if (item.value > 0)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.circle_outlined),
                          SizedBox(width: 15),
                          Text(
                            item.key,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "${item.value} pcs",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
