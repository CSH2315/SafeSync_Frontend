import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safesync_frontend/model/location_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addLocationToFirestore(LocationModel location) async {
    try {
      await _firestore.collection('locations').add(location.toMap());
    } catch (e) {
      print('Error adding location to Firestore: $e');
    }
  }
}
