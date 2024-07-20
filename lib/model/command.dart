enum Command {
  token,
  startRecording,
  stopRecording,
  refId,
  unknown;

  String get stringValue => switch (this) {
        token => 'TOKEN',
        startRecording => 'START_RECORDING',
        stopRecording => 'STOP_RECORDING',
        refId => 'REF_ID',
        unknown => 'UNKNOWN',
      };

  static Command fromString(String value) => switch (value) {
        'TOKEN' => token,
        'START_RECORDING' => startRecording,
        'STOP_RECORDING' => stopRecording,
        _ => value.startsWith('REF_ID')
            ? refId
            : value.startsWith('START_RECORDING')
                ? startRecording
                : unknown,
      };
}
