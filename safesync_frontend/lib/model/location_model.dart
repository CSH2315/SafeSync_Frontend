import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  final String documentId;
  final String creator;
  final double latitude;
  final double longitude;

  LocationModel({
    required this.documentId,
    required this.creator,
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.fromMap(String documentId, Map<String, dynamic> map) {
    return LocationModel(
      documentId: documentId,
      creator: map['creator'],
      latitude: map['lat'],
      longitude: map['lng'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'creator': creator,
      'lat': latitude,
      'lng': longitude,
    };
  }
}
