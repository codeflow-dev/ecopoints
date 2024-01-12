// // ignore_for_file: unused_local_variable, unnecessary_string_interpolations, require_trailing_commas, avoid_print

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecopoints/models/item.dart';
// import 'package:ecopoints/pages/agent.dart';
// import 'package:ecopoints/pages/store.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AgentLocation extends StatelessWidget {
//   const AgentLocation({super.key});
//   @override
//   Widget build(BuildContext context) {
//     AgentService agentService = AgentService();
//     Future<void> calcAvailability() async {
//       final store = context.read<Store>();
//       List<Item> cart = store.cart;
//       try {
//         final CollectionReference collectionRef =
//             FirebaseFirestore.instance.collection('agent');
//         QuerySnapshot querySnapshot = await collectionRef.get();

//         for (DocumentSnapshot document in querySnapshot.docs) {
//           Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//           int f = 0;
//           for (int i = 0; i < cart.length; i++) {
//             int quantity = data['${cart[i].name}'];
//             print(cart[i].name);
//             if (quantity < cart[i].getQuantity()) {
//               f = 1;
//             }
//           }
//           if (f == 0) {
//             await document.reference.update(<String, dynamic>{
//               'approved': true,
//             });
//           }
//         }
//       } on Exception catch (error) {
//         print("Error looping through documents: $error");
//       }
//     }

//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Color.fromARGB(255, 68, 158, 71),
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(Icons.chevron_left),
//           ),
//           title: Text("Choose an Agent"),
//           centerTitle: true,
//         ),
//         body: FutureBuilder(
//             future: agentService.fetchAgents(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else if (snapshot.hasError) {
//                 return Text("Error fetching agenst :${snapshot.error}");
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return Text("No agents available");
//               } else {
//                 List<Agent> agents = snapshot.data!;

//                 calcAvailability();
//                 return LayoutBuilder(
//                   builder: (context, constraints) {
//                     return SingleChildScrollView(
//                       child: ConstrainedBox(
//                         constraints:
//                             BoxConstraints(minHeight: constraints.maxHeight),
//                         child: Column(
//                             children: List.generate(
//                                 agents.length,
//                                 (index) => Card(
//                                       child: SizedBox(
//                                         height: 120,
//                                         child: Stack(
//                                           children: [
//                                             Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           left: 20),
//                                                   child: ListTile(
//                                                     leading: Icon(
//                                                       Icons.person,
//                                                       size: 45,
//                                                       color: Colors.white,
//                                                     ),
//                                                     title: Text(
//                                                       "${agents[index].name}",
//                                                       style: TextStyle(
//                                                         fontSize: 20,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                     subtitle: Text(
//                                                       "${agents[index].location}",
//                                                       style: TextStyle(
//                                                         fontSize: 15,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                             Positioned(
//                                               right: 50,
//                                               top: 20,
//                                               child: Icon(
//                                                 agents[index].approved
//                                                     ? Icons.task_alt_rounded
//                                                     : Icons
//                                                         .highlight_off_rounded,
//                                                 color: agents[index].approved
//                                                     ? Color.fromARGB(
//                                                         255, 114, 212, 54)
//                                                     : Color.fromARGB(
//                                                         255, 224, 56, 56),
//                                                 size: 40,
//                                               ),
//                                             ),
//                                             Positioned(
//                                               right: 39,
//                                               top: 70,
//                                               child: Text(
//                                                 agents[index].approved
//                                                     ? "Available"
//                                                     : "Unavailable",
//                                                 style: TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: agents[index].approved
//                                                       ? const Color.fromARGB(
//                                                           255,
//                                                           114,
//                                                           212,
//                                                           54) // Color for available status
//                                                       : const Color.fromARGB(
//                                                           255,
//                                                           224,
//                                                           56,
//                                                           56), // Color for unavailable status
//                                                 ),
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ))),
//                       ),
//                     );
//                   },
//                 );
//               }
//             }));
//   }
// }

// // class Agent {
// //   String name;
// //   String location;
// //   bool approved;

// //   Agent({required this.name, required this.location, required this.approved});
// // }

// // class AgentService {
// //   final CollectionReference agentsCollection =
// //       FirebaseFirestore.instance.collection("agent");

// //   Future<List<Agent>> fetchAgents() async {
// //     try {
// //       QuerySnapshot querySnapshot = await agentsCollection.get();
// //       List<Agent> agents = querySnapshot.docs.map((doc) {
// //         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
// //         return Agent(
// //           name: data['firstName'] ?? "",
// //           location: data['location'] ?? "",
// //           approved: data['approved'] ?? false,
// //         );
// //       }).toList();
// //       return agents;
// //     } on Exception catch (_) {
// //       print("Error fetching agents: $_");
// //       return [];
// //     }
// //   }
// // }
// ignore_for_file: unused_local_variable, unnecessary_string_interpolations, require_trailing_commas, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopoints/models/item.dart';
import 'package:ecopoints/pages/agent.dart';
import 'package:ecopoints/pages/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgentLocation extends StatefulWidget {
  const AgentLocation({Key? key}) : super(key: key);

  @override
  _AgentLocationState createState() => _AgentLocationState();
}

class _AgentLocationState extends State<AgentLocation> {
  AgentService agentService = AgentService();

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
          int quantity = data['${cart[i].name}'];
          if (quantity < cart[i].getQuantity()) {
            f = 1;
          }
        }
        if (f == 0) {
          await document.reference.update(<String, dynamic>{
            'available': true,
          });
        }
      }
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
            icon: Icon(Icons.chevron_left),
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

                // calcAvailability();
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                            children: List.generate(
                                agents.length,
                                (index) => Card(
                                      child: SizedBox(
                                        height: 120,
                                        child: Stack(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      "${agents[index].location}",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                agents[index].available
                                                    ? Icons.task_alt_rounded
                                                    : Icons
                                                        .highlight_off_rounded,
                                                color: agents[index].available
                                                    ? Color.fromARGB(
                                                        255, 114, 212, 54)
                                                    : Color.fromARGB(
                                                        255, 224, 56, 56),
                                                size: 40,
                                              ),
                                            ),
                                            Positioned(
                                              right: 39,
                                              top: 70,
                                              child: Text(
                                                agents[index].available
                                                    ? "Available"
                                                    : "Unavailable",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: agents[index].available
                                                      ? const Color.fromARGB(
                                                          255,
                                                          114,
                                                          212,
                                                          54) // Color for available status
                                                      : const Color.fromARGB(
                                                          255,
                                                          224,
                                                          56,
                                                          56), // Color for unavailable status
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))),
                      ),
                    );
                  },
                );
              }
            }));
  }
}
