import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safesync_frontend/model/location_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Firestore에서 위치 정보를 가져오는 함수
Future<List<LocationModel>> getLocationsFromFirestore() async {
  try {
    // Firestore의 'location' 컬렉션에서 위치 정보를 가져옵니다.
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('location').get();

    // 위치 정보를 담을 리스트
    List<LocationModel> locationsList = [];

    // 가져온 위치 정보를 LocationModel 객체로 변환하여 리스트에 추가합니다.
    querySnapshot.docs.forEach((doc) {
      LocationModel location = LocationModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      locationsList.add(location);
    });

    return locationsList;
  } catch (e) {
    // 에러 발생 시 에러 메시지 출력
    print('Error fetching locations: $e');
    return [];
  }
}
