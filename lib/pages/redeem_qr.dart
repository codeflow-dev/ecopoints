import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RedeemQRPage extends StatelessWidget {
  final String id;

  const RedeemQRPage(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transaction Complete")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: QrImageView(
                  data: "{\"type\": \"redeem\", \"id\": \"$id\"}",
                ),
              ),
            ),
            Text(
              "Please take a screenshot of this QR code and show it the agent.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
