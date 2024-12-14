import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  final String _apiKey =
      "REPLACE YOUR API KEY HERE"; // map api key REPLACE YOUR API KEY HERE

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

  @override
  void initState() {
    super.initState();
    _loadNearbyRestaurants();
  }

  /// 獲取附近餐廳並更新地圖標記
  Future<void> _loadNearbyRestaurants() async {
    try {
      final newMarkers = await fetchAndCreateMarkers(_center, _apiKey);
      setState(() {
        _markers.addAll(newMarkers);
      });
    } catch (e) {
      print('Error fetching restaurants: $e');
    }
  }

  /// 獲取附近餐廳並更新地圖標記
  Future<Set<Marker>> fetchAndCreateMarkers(
      LatLng location, String apiKey) async {
    // 請求 URL 的基礎結構
    final String url = 'https://places.googleapis.com/v1/places:searchNearby';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': apiKey,
        'X-Goog-FieldMask': 'places.displayName,places.location,places.id'
      },
      body: jsonEncode({
        'includedTypes': ['restaurant'],
        'maxResultCount': 10,
        'locationRestriction': {
          'circle': {
            'center': {
              'latitude': 25.09108,
              'longitude': 121.5598,
            },
            'radius': 500.0,
          },
        },
      }),
    );

    if (response.statusCode == 200) {
      // 請求成功
      print('Response data: ${response.body}');
      List<dynamic> places = jsonDecode(response.body)['places'];
      Set<Marker> markers = {};

      for (var place in places) {
        final markerId = MarkerId(place['id']);
        final marker = Marker(
          markerId: markerId,
          position: LatLng(
              place['location']['latitude'], place['location']['longitude']),
          infoWindow: InfoWindow(title: place['displayName']['text']),
        );
        markers.add(marker);
      }

      return markers;
    } else {
      // 請求失敗
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to load markers: ${response.statusCode}');
    }
  }
}
