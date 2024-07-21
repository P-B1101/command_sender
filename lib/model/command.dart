enum Command {
  token,
  visitId,
  standby,
  dateTime,
  startRecording,
  stopRecording,
  rfId,
  unknown;

  String get stringValue => switch (this) {
        standby => 'STANDBY',
        dateTime => 'DATE_TIME',
        visitId => 'VISIT_ID',
        token => 'TOKEN',
        startRecording => 'START_RECORDING',
        stopRecording => 'STOP_RECORDING',
        rfId => 'RF_ID',
        unknown => 'UNKNOWN',
      };

  static Command fromString(String value) => switch (value) {
        'TOKEN' => token,
        'START_RECORDING' => startRecording,
        'STOP_RECORDING' => stopRecording,
        _ => () {
            if (value.startsWith('RF_ID')) return rfId;
            if (value.startsWith('START_RECORDING')) return startRecording;
            if (value.startsWith('VISIT_ID')) return visitId;
            if (value.startsWith('DATE_TIME')) return dateTime;
            if (value.startsWith('STANDBY')) return standby;
            return unknown;
          }(),
      };
}
