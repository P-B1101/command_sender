enum Command {
  token,
  visitId,
  standby,
  dateTime,
  startRecording,
  stopRecording,
  cancelRecording,
  rfId,
  version,
  startStatus,
  stopStatus,
  cancelStatus,
  unknown;

  String get stringValue => switch (this) {
        standby => 'STANDBY',
        dateTime => 'DATE_TIME',
        visitId => 'VISIT_ID',
        token => 'TOKEN',
        startRecording => 'START_RECORDING',
        stopRecording => 'STOP_RECORDING',
        cancelRecording => 'CANCEL_RECORDING',
        rfId => 'RFID',
        version => 'VERSION',
        startStatus => 'START_STATUS',
        stopStatus => 'STOP_STATUS',
        cancelStatus => 'CANCEL_STATUS',
        unknown => 'UNKNOWN',
      };

  static Command fromString(String value) => switch (value) {
        'TOKEN' => token,
        'START_RECORDING' => startRecording,
        'STOP_RECORDING' => stopRecording,
        'CANCEL_RECORDING' => cancelRecording,
        _ => () {
            if (value.startsWith('RFID')) return rfId;
            if (value.startsWith('START_RECORDING')) return startRecording;
            if (value.startsWith('VISIT_ID')) return visitId;
            if (value.startsWith('DATE_TIME')) return dateTime;
            if (value.startsWith('STANDBY')) return standby;
            if (value.startsWith('VERSION')) return version;
            if (value.startsWith('START_STATUS')) return startStatus;
            if (value.startsWith('STOP_STATUS')) return stopStatus;
            if (value.startsWith('CANCEL_STATUS')) return cancelStatus;
            return unknown;
          }(),
      };
}
