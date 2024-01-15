import 'dart:convert';

import 'package:ecopoints/pages/agent_redeem_data.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AgentRedeemScanPage extends StatelessWidget {
  const AgentRedeemScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Redeem QR Scan')),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        onDetect: (capture) async {
          try {
            if (capture.barcodes.isNotEmpty) {
              final json = jsonDecode(capture.barcodes[0].rawValue!)
                  as Map<String, dynamic>;

              if (json['type'] == 'redeem') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgentRedeemDataPage(json['id']),
                  ),
                );
              }
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        },
      ),
    );
  }
}
