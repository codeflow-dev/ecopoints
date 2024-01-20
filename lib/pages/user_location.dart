import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as osm;

class UserLocationPage extends StatelessWidget {
  UserLocationPage({super.key});

  final agentDocs = FirebaseFirestore.instance.collection("agent").get();

  MapController controller = MapController.withPosition(
    initPosition: osm.GeoPoint(
      latitude: 23.777176,
      longitude: 90.399452,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: agentDocs,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: Text("Error")),
            );
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Scaffold(
              appBar: AppBar(title: Text("Error loading agents")),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            final agentDocs = snapshot.data!.docs;
            final agents = agentDocs.where((element) {
              final data = element.data();
              return data.containsKey("latitude") &&
                  data.containsKey("longitude");
            }).map((e) {
              final data = e.data();
              return StaticPositionGeoPoint(
                  e.id,
                  MarkerIcon(
                    icon: Icon(
                      Icons.person,
                      color: Colors.green,
                      size: 32,
                    ),
                  ),
                  [
                    osm.GeoPoint(
                      latitude: data["latitude"],
                      longitude: data["longitude"],
                    )
                  ]);
            }).toList();
            print(agents);
            return Scaffold(
              appBar: AppBar(title: Text("Agent Locations")),
              body: MapWidget(
                controller: controller,
                points: agents,
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(title: Text("Loading...")),
          );
        });
  }
}

class MapWidget extends StatelessWidget {
  const MapWidget({
    super.key,
    required this.controller,
    required this.points,
  });
  final MapController controller;
  final List<StaticPositionGeoPoint> points;
  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      controller: controller,
      mapIsLoading: Center(
        child: CircularProgressIndicator(),
      ),
      osmOption: OSMOption(
        enableRotationByGesture: true,
        zoomOption: ZoomOption(
          initZoom: 6.75,
          minZoomLevel: 3,
          maxZoomLevel: 19,
          stepZoom: 1.0,
        ),
        staticPoints: points,
        markerOption: MarkerOption(
          defaultMarker: MarkerIcon(
            icon: Icon(
              Icons.home,
              color: Colors.orange,
              size: 32,
            ),
          ),
          advancedPickerMarker: MarkerIcon(
            icon: Icon(
              Icons.location_searching,
              color: Colors.green,
              size: 56,
            ),
          ),
        ),
        showDefaultInfoWindow: false,
      ),
    );
  }
}
