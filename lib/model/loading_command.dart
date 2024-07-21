enum HeaderCommand {
  size,
  refId,
  startRecordingLoading,
  startRecordingDone,
  stopRecordingLoading,
  stopRecordingDone,
  unknown;

  String get stringValue => switch (this) {
        size => 'SIZE',
        refId => 'REF_ID',
        startRecordingLoading => 'START_RECORDING_LOADING',
        startRecordingDone => 'START_RECORDING_DONE',
        stopRecordingLoading => 'STOP_RECORDING_LOADING',
        stopRecordingDone => 'STOP_RECORDING_DONE',
        unknown => 'UNKNOWN',
      };

  static HeaderCommand fromString(String value) => switch (value) {
        'START_RECORDING_LOADING' => startRecordingLoading,
        'START_RECORDING_DONE' => startRecordingDone,
        'STOP_RECORDING_LOADING' => stopRecordingLoading,
        'STOP_RECORDING_DONE' => stopRecordingDone,
        _ => value.startsWith('REF_ID')
            ? refId
            : value.startsWith('SIZE')
                ? size
                : unknown,
      };
}
