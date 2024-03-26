enum ReportStatus {
  init,
  submitting,
  success,
  error,
}

class ReportState {
  final ReportStatus reportStatus;

  const ReportState({
    required this.reportStatus,
  });

  factory ReportState.init() {
    return ReportState(
      reportStatus: ReportStatus.init,
    );
  }

  ReportState copyWith({
    ReportStatus? reportStatus,
  }) {
    return ReportState(
      reportStatus: reportStatus ?? this.reportStatus,
    );
  }
}