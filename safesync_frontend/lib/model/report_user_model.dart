import 'package:cloud_firestore/cloud_firestore.dart';

class ReportUserModel {
  final String reporter_user_uid;
  final String reported_user_uid;
  final String reason;
  final Timestamp createdAt;

  const ReportUserModel({
    required this.reporter_user_uid,
    required this.reported_user_uid,
    required this.reason,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'reporter_user_uid': reporter_user_uid,
      'reported_user_uid': reported_user_uid,
      'reason': reason,
      'created_at': createdAt,
    };
  }

  factory ReportUserModel.fromMap(
      Map<String, dynamic> map
      ) {
    return ReportUserModel(
      reporter_user_uid: map['reporter_user_uid'],
      reported_user_uid: map['reported_user_uid'],
      reason: map['reason'],
      createdAt: map['created_at'],
    );
  }
}