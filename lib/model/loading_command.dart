enum LoadingCommand {
  startRecordingLoading,
  startRecordingDone,
  stopRecordingLoading,
  stopRecordingDone,
  unknown;

  String get stringValue => switch (this) {
        startRecordingLoading => 'START_RECORDING_LOADING',
        startRecordingDone => 'START_RECORDING_DONE',
        stopRecordingLoading => 'STOP_RECORDING_LOADING',
        stopRecordingDone => 'STOP_RECORDING_DONE',
        unknown => 'UNKNOWN',
      };

  static LoadingCommand fromString(String value) => switch (value) {
        'START_RECORDING_LOADING' => startRecordingLoading,
        'START_RECORDING_DONE' => startRecordingDone,
        'STOP_RECORDING_LOADING' => stopRecordingLoading,
        'STOP_RECORDING_DONE' => stopRecordingDone,
        _ => unknown,
      };
}
