import 'package:cloud_firestore/cloud_firestore.dart';

class ReportFeedModel {
  final String reporter_user_uid;
  final String reported_feed_uid;
  final String reason;
  final Timestamp createdAt;

  const ReportFeedModel({
    required this.reporter_user_uid,
    required this.reported_feed_uid,
    required this.reason,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'reporter_user_uid': reporter_user_uid,
      'reported_feed_uid': reported_feed_uid,
      'reason': reason,
      'created_at': createdAt,
    };
  }

  factory ReportFeedModel.fromMap(
      Map<String, dynamic> map
      ) {
    return ReportFeedModel(
      reporter_user_uid: map['reporter_user_uid'],
      reported_feed_uid: map['reported_feed_uid'],
      reason: map['reason'],
      createdAt: map['created_at'],
    );
  }
}