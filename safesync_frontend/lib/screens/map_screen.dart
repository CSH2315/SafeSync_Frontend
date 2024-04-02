import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safesync_frontend/providers/locations.dart' as locations;

import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;

  final CameraPosition _position = CameraPosition(target: LatLng(41.017901, 28.847953));

  final List<Marker> markers = [];

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _currentLocation() async {
    final GoogleMapController controller = await _controller;
    Location location = Location();
    final currentLocation = await location.getLocation();

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 18.0,
      )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: _position,
        ),
      ),
    );
  }
}