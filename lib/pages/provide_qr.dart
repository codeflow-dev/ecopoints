import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProvideQRPage extends StatelessWidget {
  final String id;
  final int points;

  const ProvideQRPage(this.id, this.points, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transaction Complete")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: QrImageView(
                  data: "{'type': 'provide_transaction', 'id': '$id'}"),
            ),
          ),
          Text(
            "Please ask the user to scan the QR code and collect $points points",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ]),
      ),
    );
  }
}
