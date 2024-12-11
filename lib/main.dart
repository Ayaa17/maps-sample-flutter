import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late GoogleMapController _mapController;

  final LatLng _center = const LatLng(25.09108, 121.5598); // San Francisco

  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('marker_1'),
      position: LatLng(25.09108, 121.5598), // San Francisco
      infoWindow: InfoWindow(
        title: 'San Francisco',
        snippet: 'Golden Gate Bridge',
      ),
    ),
    Marker(
      markerId: MarkerId('marker_2'),
      position: LatLng(24.91571, 121.6739), // San Francisco
      infoWindow: InfoWindow(
        title: 'San Francisco',
        snippet: 'Golden Gate Bridge',
      ),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Example'),
        backgroundColor: Colors.blue,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 10.0,
        ),
        markers: _markers,
      ),
    );
  }
}
