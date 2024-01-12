// // ignore_for_file: avoid_print

// import 'package:cloud_firestore/cloud_firestore.dart';

// class Agent {
//   String name;
//   String location;
//   bool approved;

//   Agent({required this.name, required this.location, required this.approved});
// }

// List<Agent> get agent => _agent;
// final CollectionReference agentCollection =
//     FirebaseFirestore.instance.collection("agent");

// Future<List<Agent>> fetchAgents() async {
//   try {

//     QueryDocumentSnapshot querySnapshot = await agentCollection.get();
//     List<Agent> agents = querySnapshot.docs.map((doc) {
//       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//       return Agent(
//         name: data['firstName'] ?? "",
//         location: data['location'] ?? "",
//         approved: data['approved'] ?? false,
//       );
//     }).toList();
//     print(agents);
//     return _agent;
//   } on Exception catch (_) {
//     print("agent fetching failed $_");
//     return [];
//   }
// }

// final List<Agent> _agent = [];
// Future<void> fetchAndSetAgents() async {
//   List<Agent> fetchedAgents = await fetchAgents();
//   _agent.clear();
//   _agent.addAll(fetchedAgents);
// }

// // final List<Agent> _agent = [
// //   Agent(name: "Agent1", location: "Ocean", approved: false),
// //   Agent(name: "Agent2", location: "Underground", status: true),
// //   Agent(name: "Agent3", location: "Sky", status: false),
// //   Agent(name: "Agent4", location: "Hill", status: true),
// // ];

// ignore_for_file: avoid_print, require_trailing_commas, unused_element

// getAgent() {
//   return agent;
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class Agent {
  String name;
  String location;
  bool available;

  Agent({required this.name, required this.location, required this.available});
}

class AgentService {
  final CollectionReference agentsCollection =
      FirebaseFirestore.instance.collection("agent");

  Future<List<Agent>> fetchAgents() async {
    try {
      QuerySnapshot querySnapshot = await agentsCollection.get();
      List<Agent> agents = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Agent(
          name: data['firstName'] ?? "",
          location: data['location'] ?? "",
          available: data['available'] ?? false,
        );
      }).toList();
      return agents;
    } on Exception catch (_) {
      print("Error fetching agents: $_");
      return [];
    }
  }
}
