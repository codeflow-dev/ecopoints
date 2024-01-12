// ignore_for_file: require_trailing_commas, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopoints/pages/provide_qr.dart';
import 'package:flutter/material.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({super.key});

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
  final items = [
    ItemRow("Plastic", 10),
    ItemRow("Plastic", 10),
    ItemRow("Plastic", 10),
  ];

  int totalPoints() {
    var total = 0;
    for (var item in items) {
      total += item.product();
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculate Points")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Table(
              children: [
                for (var item in items)
                  TableRow(
                    children: [
                      TableTextCell(item.name),
                      RoundedTextField(
                        editingController: item.quantityController,
                        onChanged: (value) {
                          setState(() {
                            if (value.trim() == "") {
                              item.quan = 0;
                            } else {
                              item.quan = int.parse(value.trim());
                            }
                          });
                        },
                      ),
                      TableTextCell(
                        "${item.product()}",
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: SizedBox(height: 1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Text(
                "Total              ${totalPoints()}",
                textAlign: TextAlign.right,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    content: Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 10),
                        Text("Loading"),
                      ],
                    ),
                  ),
                );
                final id = await FirebaseFirestore.instance
                    .collection("provide_transactions")
                    .add({"points": totalPoints(), "received": false});
                if (mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ProvideQRPage(id.id, totalPoints()),
                  ));
                }
              },
              child: Text("Generate QR Code"),
            )
          ],
        ),
      ),
    );
  }
}

class ItemRow {
  String name;
  int pointsPerKg;
  TextEditingController quantityController;
  int quan;

  ItemRow(this.name, this.pointsPerKg)
      : quantityController = TextEditingController(),
        quan = 0;

  int product() {
    return pointsPerKg * quan;
  }
}

class TableTextCell extends StatelessWidget {
  String data = "";
  TextAlign? textAlign;

  TableTextCell(this.data, {super.key, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          data,
          style: TextStyle(fontSize: 16),
          textAlign: textAlign,
        ),
      ),
    );
  }
}

class RoundedTextField extends StatelessWidget {
  TextEditingController? editingController;
  final ValueChanged<String>? onChanged;

  RoundedTextField({super.key, this.editingController, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: TextField(
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            controller: editingController,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
