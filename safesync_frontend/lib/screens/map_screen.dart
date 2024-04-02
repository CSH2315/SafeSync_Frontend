import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:safesync_frontend/model/location_model.dart';
import 'package:safesync_frontend/providers/locations.dart' as locations;
import 'package:safesync_frontend/providers/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  final Set<Marker> _markers = {};
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _currentLocation(); // 초기 시작 시 현재 위치로 이동
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _markers,
        onTap: _addMarker,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12.0,
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _currentLocation,
            child: Icon(Icons.location_searching),
          ),
          SizedBox(width: 16), // 간격 조정
          FloatingActionButton(
            onPressed: _saveMarkerToFirestore,
            child: Icon(Icons.save),
          ),
        ],
      ),
    );
  }


  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _getLocations();
  }

  void _addMarker(LatLng position) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  void _getLocations() async {
    List<LocationModel> locationsList = await locations.getLocationsFromFirestore();

    setState(() {
      _markers.addAll(locationsList.map((location) {
        return Marker(
          markerId: MarkerId(location.documentId),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(title: location.creator),
        );
      }));
    });
  }

  void _currentLocation() async {
    final GoogleMapController controller = await _controller;
    Location location = Location();
    final currentLocation = await location.getLocation();

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 18.0,
      ),
    ));
  }

  void _saveMarkerToFirestore() async {
    for (Marker marker in _markers) {
      final LocationModel location = LocationModel(
        documentId: '',
        latitude: marker.position.latitude,
        longitude: marker.position.longitude,
        creator: '사용자', // 임의의 사용자 정보
      );
      await _locationService.addLocationToFirestore(location);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('마커가 Firestore에 저장되었습니다.'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MapScreen(),
  ));
}
