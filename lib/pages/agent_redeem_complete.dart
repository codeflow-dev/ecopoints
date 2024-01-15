import 'package:flutter/material.dart';

class AgentRedeemCompletePage extends StatelessWidget {
  final Map items;

  const AgentRedeemCompletePage(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transaction complete")),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            Icon(Icons.check, size: 40),
            SizedBox(height: 30),
            Text(
              "Redeem Approved",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 50),
            Column(
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
          ],
        ),
      ),
    );
  }
}
