// ignore_for_file: use_super_parameters, library_private_types_in_public_api, avoid_print, avoid_function_literals_in_foreach_calls, require_trailing_commas, unnecessary_string_interpolations

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

  // Future<List<Map<String, dynamic>>> getOrders() async {
  //   try {
  //     final uid = FirebaseAuth.instance.currentUser!.uid;
  //     final CollectionReference<Map<String, dynamic>> collectionRef =
  //         FirebaseFirestore.instance.collection('orders');

  //     QuerySnapshot<Map<String, dynamic>> querySnapshot = await collectionRef
  //         .where('agent', isEqualTo: uid)
  //         .where('approved', isEqualTo: false)
  //         .get();

  //     List<Map<String, dynamic>> ordersList = [];
  //     querySnapshot.docs
  //         .forEach((QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
  //       Map<String, dynamic> order = doc.data();
  //       print("$order");
  //       order['orderId'] = doc.id;

  //       // Fetch user details based on the user ID
  //       String userId = order['user'];
  //       //print("$userId");
  //       Map<String, dynamic> userData = await getUser(userId);
  //       print("User Data: $userData");
  //       order['userName'] = userData['firstName'] + " " + userData['lastName'];
  //       ordersList.add(order);
  //     });
  //     print("HI $ordersList");
  //     return ordersList;
  //   } catch (_) {
  //     print("Error in fetching orders: $_");
  //     return [];
  //   }
  // }
  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final CollectionReference<Map<String, dynamic>> collectionRef =
          FirebaseFirestore.instance.collection('orders');

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await collectionRef
          .where('agent', isEqualTo: uid)
          .where('approved', isEqualTo: false)
          .get();

      List<Map<String, dynamic>> ordersList = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        Map<String, dynamic> order = doc.data();
        print("$order");
        order['orderId'] = doc.id;

        // Fetch user details based on the user ID
        String userId = order['user'];
        //print("$userId");
        Map<String, dynamic> userData = await getUser(userId);
        print("User Data: $userData");
        order['userName'] = userData['firstName'] + " " + userData['lastName'];
        ordersList.add(order);
      }

      print("HI $ordersList");
      return ordersList;
    } catch (error) {
      print("Error in fetching orders: $error");
      return [];
    }
  }

  Future<Map<String, dynamic>> getUser(String userId) async {
    try {
      final CollectionReference<Map<String, dynamic>> userCollectionRef =
          FirebaseFirestore.instance.collection('user');

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await userCollectionRef.doc(userId).get();

      return userSnapshot.data() ?? {};
    } catch (_) {
      print("Error in fetching user data: $_");
      return {};
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
  /*Widget build(BuildContext context) {
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
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No orders found.');
                } else {
                  return Column(
                    children: [
                      Text(
                        "Pending Orders",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SingleChildScrollView(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> order = snapshot.data![index];
                            return Card(
                              margin: EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Icon(Icons.account_circle_rounded,
                                        size: 35.0),
                                    SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        '${order['userName']}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.0),
                                    ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          await approveOrder(order['orderId']);
                                          setState(() {
                                            orders = getOrders();
                                          });
                                        } on Exception catch (error) {
                                          print(
                                              "Error approving order: $error");
                                        }
                                      },
                                      child: Text('Approve'),
                                    ),
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text(
                                    "Bottle: ${order['bottle']}kg \nCarton: ${order['carton']} kg \nIron: ${order['iron']} kg \nPlastic: ${order['plastic']} kg \nPaper: ${order['paper']} kg ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Text(
                      //   "Order History",
                      //   style: TextStyle(
                      //       fontSize: 20, fontWeight: FontWeight.bold),
                      // ),
                    ],
                  );
                }
              },
            )*/

  // child: FutureBuilder<List<Map<String, dynamic>>>(
  //   future: orders,
  //   builder: (context, snapshot) {
  //     if (snapshot.connectionState == ConnectionState.waiting) {
  //       return Center(child: CircularProgressIndicator());
  //     } else if (snapshot.hasError) {
  //       return Text('Error: ${snapshot.error}');
  //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //       return Text('No orders found.');
  //     } else {
  //       return SingleChildScrollView(
  //         child: Column(
  //           children: [
  //             Text(
  //               "Pending Orders",
  //               style: TextStyle(
  //                   fontSize: 20, fontWeight: FontWeight.bold),
  //             ),
  //             ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: snapshot.data!.length,
  //               itemBuilder: (context, index) {
  //                 Map<String, dynamic> order = snapshot.data![index];
  //                 return Card(
  //                   margin: EdgeInsets.all(8.0),
  //                   child: ListTile(
  //                       title: Text('${order['userName']}',
  //                           style: TextStyle(
  //                               fontSize: 18,
  //                               fontWeight: FontWeight.bold)),
  //                       subtitle: Text(
  //                           "Bottle: ${order['bottle']}kg \nCarton: ${order['carton']} kg \nIron: ${order['iron']} kg \nPlastic: ${order['plastic']} kg \nPaper: ${order['paper']} kg ",
  //                           style: TextStyle(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.bold)),
  //                       trailing: ElevatedButton(
  //                         onPressed: () {
  //                           try {
  //                             approveOrder(order['orderId']);
  //                             setState(() {
  //                               orders = getOrders();
  //                             });
  //                           } on Exception catch (_) {
  //                             print("error $_");
  //                           }
  //                         },
  //                         child: Text('Approve'),
  //                       )),
  //                 );
  //               },
  //             ),
  //             Text(
  //               "Order History",
  //               style: TextStyle(
  //                   fontSize: 20, fontWeight: FontWeight.bold),
  //             ),
  //             // ListView.builder(
  //             //   shrinkWrap: true,
  //             //   itemCount: snapshot.data!.length,
  //             //   itemBuilder: (context, index) {
  //             //     Map<String, dynamic> order = snapshot.data![index];
  //             //     return Card(
  //             //       margin: EdgeInsets.all(8.0),
  //             //       child: ListTile(
  //             //           title: Text(
  //             //               "Bottle: ${order['bottle']} | Carton: ${order['carton']} | Iron: ${order['iron']} | Plastic: ${order['plastic']} | Iron: ${order['paper']}"),
  //             //           trailing: ElevatedButton(
  //             //             onPressed: () {
  //             //               try {
  //             //                 approveOrder(order['orderId']);
  //             //                 setState(() {
  //             //                   orders = getOrders();
  //             //                 });
  //             //               } on Exception catch (_) {
  //             //                 print("error $_");
  //             //               }
  //             //             },
  //             //             child: Text('Approve'),
  //             //           )),
  //             //     );
  //             //   },
  //             // ),
  //           ],
  //         ),
  //       );
  //     }
  //   },
  // ),
  /*),
      ),
    );
  }
}*/
  @override
  Widget build(BuildContext context) {
    String capitalize(String input) {
      return input[0].toUpperCase() + input.substring(1);
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 68, 158, 71),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text("Orders"),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: orders,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No orders found.'));
                } else {
                  return
                      // return Column(
                      //   children: [
                      //     Text(
                      //       "Pending Orders",
                      //       style: TextStyle(
                      //         fontSize: 20,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> order = snapshot.data![index];
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Row(
                              children: [
                                Icon(Icons.account_circle_rounded, size: 35.0),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    '${order['userName']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await approveOrder(order['orderId']);
                                      setState(() {
                                        orders = getOrders();
                                      });
                                    } on Exception catch (error) {
                                      print("Error approving order: $error");
                                    }
                                  },
                                  child: Text('Approve'),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                columnWidths: {
                                  0: FlexColumnWidth(3),
                                  1: FlexColumnWidth(1),
                                },
                                children: [
                                  for (var entry in order.entries)
                                    if (entry.key != 'userName' &&
                                        entry.key != 'orderId' &&
                                        entry.key != 'agent' &&
                                        entry.key != 'user' &&
                                        entry.key != 'approved')
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Text(
                                                "${capitalize(entry.key)}"),
                                          ),
                                          TableCell(
                                            child: Text("${entry.value} kg"),
                                          ),
                                        ],
                                      ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                  //   ],
                  // );
                }
              },
            )));
  }
}
