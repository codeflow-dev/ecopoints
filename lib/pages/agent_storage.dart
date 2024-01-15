import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StoragePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stored Iteams'),
      ),
      body: FutureBuilder(
        future: getAgentData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available.'));
          }

          Map<String, dynamic> agentData = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Agent Inventory for ${agentData['firstName']} ${agentData['lastName']}",
                ),
                SizedBox(height: 20),
                buildInventoryRow('Bottle', agentData['bottle']),
                buildInventoryRow('Carton', agentData['carton']),
                buildInventoryRow('Iron', agentData['iron']),
                buildInventoryRow('Paper', agentData['paper']),
                buildInventoryRow('Plastic', agentData['plastic']),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildInventoryRow(String itemName, dynamic quantity) {
    // Use null-aware operator to handle potential null value or non-int value
    final displayQuantity = quantity is int ? quantity : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text('$itemName: $displayQuantity (number)'),
    );
  }

  Future<Map<String, dynamic>> getAgentData() async {
    try {
      final agentDocument = await FirebaseFirestore.instance
          .collection("agent")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (agentDocument.exists) {
        return agentDocument.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (error) {
      print('Error fetching agent data: $error');
      return {};
    }
  }
}
