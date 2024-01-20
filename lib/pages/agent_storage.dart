import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopoints/common.dart';
import 'package:ecopoints/pages/agent_calculate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StoragePage extends StatelessWidget {
  const StoragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stored Items'),
        centerTitle: true,
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 20),
                Table(
                  children: [
                    TableRow(
                      children: [
                        TableTextCell("Bottle"),
                        TableTextCell(agentData['bottle'].toString()),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableTextCell("Carton"),
                        TableTextCell(agentData['carton'].toString()),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableTextCell("Iron"),
                        TableTextCell(agentData['iron'].toString()),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableTextCell("Paper"),
                        TableTextCell(agentData['paper'].toString()),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableTextCell("Plastic"),
                        TableTextCell(agentData['plastic'].toString()),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
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
      showToast('Error fetching agent data: $error');
      return {};
    }
  }
}
