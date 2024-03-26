import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safesync_frontend/exceptions/custom_exception.dart';
import 'package:safesync_frontend/model/report_feed_model.dart';
import 'package:safesync_frontend/model/report_user_model.dart';
import 'package:uuid/uuid.dart';

class ReportRepository {
  final FirebaseFirestore firebaseFirestore;

  const ReportRepository({
    required this.firebaseFirestore,
  });

  Future<void> reportUser({
    required String reporter_user_uid,
    required String reported_user_uid,
    required String reason,
  }) async {
    try {
      String reportUID = Uuid().v4();

      DocumentReference<Map<String, dynamic>> reportDocRef = firebaseFirestore.collection('reports_users').doc(reportUID);

      ReportUserModel reportModel = ReportUserModel(
        reporter_user_uid: reporter_user_uid,
        reported_user_uid: reported_user_uid,
        reason: reason,
        createdAt: Timestamp.now(),
      );

      reportDocRef.set(reportModel.toMap());
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message!,
      );
    } on CustomException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message,
      );
    } catch (e) {
      throw CustomException(
        code: 'Exception(Internal)',
        message: e.toString(),
      );
    }
  }

  Future<void> reportFeed({
    required String reporter_user_uid,
    required String reported_feed_uid,
    required String reason,
  }) async {
    try {
      String reportUID = Uuid().v4();

      DocumentReference<Map<String, dynamic>> reportDocRef = firebaseFirestore.collection('reports_feed').doc(reportUID);

      ReportFeedModel reportModel = ReportFeedModel(
        reporter_user_uid: reporter_user_uid,
        reported_feed_uid: reported_feed_uid,
        reason: reason,
        createdAt: Timestamp.now(),
      );

      reportDocRef.set(reportModel.toMap());
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message!,
      );
    } on CustomException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message,
      );
    } catch (e) {
      throw CustomException(
        code: 'Exception(Internal)',
        message: e.toString(),
      );
    }
  }
}