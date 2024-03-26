import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:safesync_frontend/exceptions/custom_exception.dart';
import 'package:safesync_frontend/providers/report/report_state.dart';
import 'package:safesync_frontend/repositories/report_repository.dart';

class ReportProvider extends StateNotifier<ReportState> with LocatorMixin {
  ReportProvider() : super(ReportState.init());

  Future<void> reportUser({
    required String reporter_user_uid,
    required String reported_user_uid,
    required String reason,
  }) async {
    try{
      state = state.copyWith(reportStatus: ReportStatus.submitting);

      await read<ReportRepository>().reportUser(
        reporter_user_uid: reporter_user_uid,
        reported_user_uid: reported_user_uid,
        reason: reason,
      );

      state = state.copyWith(reportStatus: ReportStatus.success);
    } on CustomException catch(_) {
      state = state.copyWith(reportStatus: ReportStatus.error);
      rethrow;
    }
  }

  Future<void> reportFeed({
    required String reporter_user_uid,
    required String reported_feed_uid,
    required String reason,
  }) async {
    try{
      state = state.copyWith(reportStatus: ReportStatus.submitting);

      await read<ReportRepository>().reportFeed(
        reporter_user_uid: reporter_user_uid,
        reported_feed_uid: reported_feed_uid,
        reason: reason,
      );

      state = state.copyWith(reportStatus: ReportStatus.success);
    } on CustomException catch(_) {
      state = state.copyWith(reportStatus: ReportStatus.error);
      rethrow;
    }
  }
}