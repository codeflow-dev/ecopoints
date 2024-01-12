import 'dart:convert';

import 'package:ecopoints/pages/user_scan_complete.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class UserScanPage extends StatelessWidget {
  const UserScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        onDetect: (capture) async {
          try {
            if (capture.barcodes.isNotEmpty) {
              final json = jsonDecode(capture.barcodes[0].rawValue!)
                  as Map<String, dynamic>;

              if (json['type'] == 'provide_transaction') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserScanCompletePage(json['id']),
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
