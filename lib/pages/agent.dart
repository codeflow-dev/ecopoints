// ignore_for_file: avoid_print

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
