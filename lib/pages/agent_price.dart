import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopoints/common.dart';
import 'package:ecopoints/pages/agent_calculate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PriceManagementPage extends StatefulWidget {
  const PriceManagementPage({super.key});

  @override
  State<PriceManagementPage> createState() => _PriceManagementPageState();
}

class _PriceManagementPageState extends State<PriceManagementPage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> getItems() async {
    var items = await FirebaseFirestore.instance.collection("item").get();
    return items.docs.map((doc) {
      var d = doc.data();
      d['id'] = doc.id;
      return d;
    }).toList();
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

        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text("Agent does not exist")),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          var items = snapshot.data!;
          for (var i in items) {
            i["buying_controller"] = TextEditingController();
            i["selling_controller"] = TextEditingController();
            i["buying_controller"].text = i["buyingPrice"].toString();
            i["selling_controller"].text = i["sellingPrice"].toString();
          }
          return Scaffold(
            appBar: AppBar(title: Text("Profile settings")),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                showLoadingDialog(context);
                for (var i in items) {
                  Map<String, dynamic> j = Map.from(i);
                  String id = j["id"];
                  j.remove("id");

                  j["buyingPrice"] =
                      int.parse(j["buying_controller"].text.trim());
                  j["sellingPrice"] =
                      int.parse(j["selling_controller"].text.trim());
                  j.remove("buying_controller");
                  j.remove("selling_controller");
                  await FirebaseFirestore.instance
                      .collection("item")
                      .doc(id)
                      .update(j);
                }
                if (mounted) {
                  Navigator.pop(context);
                }
                showToast("Prices updated");
              },
              label: Text("Update prices"),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        TableTextCell("Item name"),
                        TableTextCell("Buying price"),
                        TableTextCell("Selling price"),
                      ],
                    ),
                    for (var item in items)
                      TableRow(
                        children: [
                          TableTextCell(
                            item["name"].toUpperCase()[0] +
                                item["name"].substring(1),
                          ),
                          RoundedTextField(
                            editingController: item["buying_controller"],
                          ),
                          RoundedTextField(
                            editingController: item["selling_controller"],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
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
