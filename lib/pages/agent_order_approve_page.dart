// ignore_for_file: use_super_parameters, library_private_types_in_public_api, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AgentOrderApprovePage extends StatefulWidget {
  const AgentOrderApprovePage({Key? key}) : super(key: key);

  @override
  _AgentOrderApprovePageState createState() => _AgentOrderApprovePageState();
}

class _AgentOrderApprovePageState extends State<AgentOrderApprovePage> {
  late Future<List<Map<String, dynamic>>> orders;

  @override
  void initState() {
    super.initState();
    orders = getOrders();
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      print(uid);
      final CollectionReference<Map<String, dynamic>> collectionRef =
          FirebaseFirestore.instance.collection('orders');

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await collectionRef
          .where('agent', isEqualTo: uid)
          .where('approved', isEqualTo: false)
          .get();

      List<Map<String, dynamic>> ordersList = [];
      querySnapshot.docs
          .forEach((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        Map<String, dynamic> order = doc.data();
        order['orderId'] = doc.id;
        ordersList.add(order);
      });
      print(ordersList);

      return ordersList;
    } catch (_) {
      print("Error in fetching orders: $_");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getApprovedOrders() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      print(uid);
      final CollectionReference<Map<String, dynamic>> collectionRef =
          FirebaseFirestore.instance.collection('orders');

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await collectionRef
          .where('agent', isEqualTo: uid)
          .where('approved', isEqualTo: true)
          .get();

      List<Map<String, dynamic>> approvedOrdersList = [];
      querySnapshot.docs
          .forEach((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        approvedOrdersList.add(doc.data());
      });
      print(approvedOrdersList);

      return approvedOrdersList;
    } catch (_) {
      print("Error in fetching orders: $_");
      return [];
    }
  }

  Future<void> approveOrder(String orderId) async {
    try {
      final CollectionReference<Map<String, dynamic>> collectionRef =
          FirebaseFirestore.instance.collection('orders');
      await collectionRef.doc(orderId).update({'approved': true});
    } on Exception catch (_) {
      print("Failed to approved $_");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 68, 158, 71),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left),
        ),
        title: Text("Orders"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: orders,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No orders found.');
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "Pending Orders",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> order = snapshot.data![index];
                          return Card(
                            margin: EdgeInsets.all(8.0),
                            child: ListTile(
                                title: Text(
                                    "Bottle: ${order['bottle']} | Carton: ${order['carton']} | Iron: ${order['iron']} | Plastic: ${order['plastic']} | Iron: ${order['paper']}"),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    try {
                                      approveOrder(order['orderId']);
                                      setState(() {
                                        orders = getOrders();
                                      });
                                    } on Exception catch (_) {
                                      print("error $_");
                                    }
                                  },
                                  child: Text('Approve'),
                                )),
                          );
                        },
                      ),
                      // Text(
                      //   "Order History",
                      //   style: TextStyle(
                      //       fontSize: 20, fontWeight: FontWeight.bold),
                      // ),
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   itemCount: snapshot.data!.length,
                      //   itemBuilder: (context, index) {
                      //     Map<String, dynamic> order = snapshot.data![index];
                      //     return Card(
                      //       margin: EdgeInsets.all(8.0),
                      //       child: ListTile(
                      //           title: Text(
                      //               "Bottle: ${order['bottle']} | Carton: ${order['carton']} | Iron: ${order['iron']} | Plastic: ${order['plastic']} | Iron: ${order['paper']}"),
                      //           trailing: ElevatedButton(
                      //             onPressed: () {
                      //               try {
                      //                 approveOrder(order['orderId']);
                      //                 setState(() {
                      //                   orders = getOrders();
                      //                 });
                      //               } on Exception catch (_) {
                      //                 print("error $_");
                      //               }
                      //             },
                      //             child: Text('Approve'),
                      //           )),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
