// ignore_for_file: unused_local_variable, unnecessary_string_interpolations, require_trailing_commas, avoid_print, use_super_parameters, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopoints/models/item.dart';
import 'package:ecopoints/pages/agent.dart';
import 'package:ecopoints/pages/store.dart';
import 'package:ecopoints/pages/user_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgentLocation extends StatefulWidget {
  const AgentLocation({Key? key}) : super(key: key);

  @override
  _AgentLocationState createState() => _AgentLocationState();
}

class _AgentLocationState extends State<AgentLocation> {
  AgentService agentService = AgentService();
  //store availability for each agent
  List<Map<String, dynamic>> agentAvailability = [];

  @override
  void initState() {
    super.initState();
    calcAvailability();
  }

  Future<void> calcAvailability() async {
    final store = context.read<Store>();
    List<Item> cart = store.cart;
    try {
      final CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('agent');
      QuerySnapshot querySnapshot = await collectionRef.get();

      for (DocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        int f = 0;
        for (int i = 0; i < cart.length; i++) {
          try {
            int quantity = data['${cart[i].name}'];
            if (quantity < cart[i].getQuantity()) {
              f = 1;
              break;
            }
          } catch (e) {
            print("Please give full info of an agent $e");
          }
        }
        agentAvailability.add({'agentId': document.id, 'availability': f == 0});
      }
      setState(() {});
    } on Exception catch (error) {
      print("Error looping through documents: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    AgentService agentService = AgentService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 68, 158, 71),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Choose an Agent"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: agentService.fetchAgents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("Error fetching agent :${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text("No agents available");
          } else {
            List<Agent> agents = snapshot.data!;

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      children: List.generate(
                        agents.length,
                        (index) => GestureDetector(
                          onTap: agentAvailability.isNotEmpty &&
                                  agentAvailability[index]['availability']
                              ? () {
                                  try {
                                    final store = context.read<Store>();
                                    final cart = store.cart;
                                    FirebaseFirestore.instance
                                        .collection('orders')
                                        .add({
                                      'agent': agentAvailability[index]
                                          ['agentId'],
                                      'user': FirebaseAuth
                                          .instance.currentUser?.uid,
                                      'bottle': store.cart
                                          .where(
                                              (item) => item.name == 'bottle')
                                          .fold<int>(
                                            0,
                                            (previousValue, item) =>
                                                previousValue +
                                                    item.getQuantity() as int,
                                          ),
                                      'carton': store.cart
                                          .where(
                                              (item) => item.name == 'carton')
                                          .fold<int>(
                                            0,
                                            (previousValue, item) =>
                                                previousValue +
                                                    item.getQuantity() as int,
                                          ),
                                      'iron': store.cart
                                          .where((item) => item.name == 'iron')
                                          .fold<int>(
                                            0,
                                            (previousValue, item) =>
                                                previousValue +
                                                    item.getQuantity() as int,
                                          ),
                                      'paper': store.cart
                                          .where((item) => item.name == 'paper')
                                          .fold<int>(
                                            0,
                                            (previousValue, item) =>
                                                previousValue +
                                                    item.getQuantity() as int,
                                          ),
                                      'plastic': store.cart
                                          .where(
                                              (item) => item.name == 'plastic')
                                          .fold<int>(
                                            0,
                                            (previousValue, item) =>
                                                previousValue +
                                                    item.getQuantity() as int,
                                          ),
                                      'approved': false,
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                              'Your order has been successfully placed'),
                                          content: Text(
                                              'Please wait for the confirmation'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).popUntil(
                                                    (route) => route.isFirst);
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserHomePage()));
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } on Exception catch (_) {
                                    print('Error in adding data in orders: $_');
                                  }
                                }
                              : null,
                          child: Card(
                            child: SizedBox(
                              height: 120,
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.person,
                                            size: 45,
                                            color: Colors.white,
                                          ),
                                          title: Text(
                                            "${agents[index].name}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${agents[index].location}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Positioned(
                                    right: 50,
                                    top: 20,
                                    child: Icon(
                                      agentAvailability[index]['availability']
                                          ? Icons.task_alt_rounded
                                          : Icons.highlight_off_rounded,
                                      color: agentAvailability[index]
                                              ['availability']
                                          ? Color.fromARGB(255, 114, 212, 54)
                                          : Color.fromARGB(255, 224, 56, 56),
                                      size: 40,
                                    ),
                                  ),
                                  Positioned(
                                    right: 39,
                                    top: 70,
                                    child: Text(
                                      agentAvailability[index]['availability']
                                          ? "Available"
                                          : "Unavailable",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: agentAvailability[index]
                                                ['availability']
                                            ? const Color.fromARGB(
                                                255, 114, 212, 54)
                                            : const Color.fromARGB(
                                                255, 224, 56, 56),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
