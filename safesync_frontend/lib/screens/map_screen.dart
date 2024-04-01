import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  bool _isNavBarVisible = true;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps Sample App'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            left: 0,
            right: 0,
            bottom: _isNavBarVisible ? kBottomNavigationBarHeight : -kBottomNavigationBarHeight * 2,
            child: Column(
              children: [
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.primaryDelta! < -20) {
                      setState(() {
                        _isNavBarVisible = false;
                      });
                    } else if (details.primaryDelta! > 20) {
                      setState(() {
                        _isNavBarVisible = true;
                      });
                    }
                  },
                  child: Container(
                    height: kBottomNavigationBarHeight,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.map),
                        ),
                        // 여기에 다른 메뉴 추가
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.green[700],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isNavBarVisible = !_isNavBarVisible;
                            });
                          },
                          icon: Icon(_isNavBarVisible ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

