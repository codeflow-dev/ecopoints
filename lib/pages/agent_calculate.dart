import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopoints/common.dart';
import 'package:ecopoints/pages/provide_qr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({super.key});

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
  List<ItemRow> items = [];

  @override
  void initState() {
    super.initState();
    getItems();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getItems() async {
    return await FirebaseFirestore.instance.collection("item").get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
          );
        }

        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text("Error loading items")),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data!.docs.map((e) => e.data()).toList();
          for (final item in data) {
            items.add(ItemRow(item["name"], item["buyingPrice"]));
          }
          return AgentCalculateWidget(items);
        }
        return Scaffold(
          appBar: AppBar(title: Text("Loading...")),
        );
      },
    );
  }
}

class AgentCalculateWidget extends StatefulWidget {
  final List<ItemRow> items;

  const AgentCalculateWidget(this.items, {super.key});

  @override
  State<AgentCalculateWidget> createState() => _AgentCalculateWidgetState();
}

class _AgentCalculateWidgetState extends State<AgentCalculateWidget> {
  int totalPoints() {
    var total = 0;
    for (var item in widget.items) {
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
                TableRow(
                  children: [
                    TableTextCell("Item name"),
                    TableTextCell("Quantity in KG"),
                    TableTextCell("Product"),
                  ],
                ),
                for (var item in widget.items)
                  TableRow(
                    children: [
                      TableTextCell(
                        item.name[0].toUpperCase() + item.name.substring(1),
                      ),
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
                showLoadingDialog(context);
                final id = await FirebaseFirestore.instance
                    .collection("provide_transactions")
                    .add({"points": totalPoints(), "received": false});
                final doc = FirebaseFirestore.instance
                    .collection("agent")
                    .doc(FirebaseAuth.instance.currentUser!.uid);
                for (var item in widget.items) {
                  await doc
                      .update({item.name: FieldValue.increment(item.quan)});
                }
                if (mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ProvideQRPage(id.id, totalPoints()),
                    ),
                  );
                }
              },
              child: Text("Generate QR Code"),
            ),
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
  final String data;
  final TextAlign? textAlign;

  const TableTextCell(this.data, {super.key, this.textAlign});

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
  final TextEditingController? editingController;
  final ValueChanged<String>? onChanged;

  const RoundedTextField({super.key, this.editingController, this.onChanged});

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
