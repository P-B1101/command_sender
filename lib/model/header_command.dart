enum HeaderCommand {
  size,
  rfId,
  startRecordingLoading,
  startRecordingDone,
  stopRecordingLoading,
  stopRecordingDone,
  cancelRecordingLoading,
  cancelRecordingDone,
  standby,
  startStatus,
  stopStatus,
  cancelStatus,
  unknown;

  String get stringValue => switch (this) {
        size => 'SIZE',
        rfId => 'RFID',
        startRecordingLoading => 'START_RECORDING_LOADING',
        startRecordingDone => 'START_RECORDING_DONE',
        stopRecordingLoading => 'STOP_RECORDING_LOADING',
        stopRecordingDone => 'STOP_RECORDING_DONE',
        cancelRecordingLoading => 'CANCEL_RECORDING_LOADING',
        cancelRecordingDone => 'CANCEL_RECORDING_DONE',
        standby => 'STANDBY',
        startStatus => 'START_STATUS',
        stopStatus => 'STOP_STATUS',
        cancelStatus => 'CANCEL_STATUS',
        unknown => 'UNKNOWN',
      };

  static HeaderCommand fromString(String value) => switch (value) {
        'START_RECORDING_LOADING' => startRecordingLoading,
        'START_RECORDING_DONE' => startRecordingDone,
        'STOP_RECORDING_LOADING' => stopRecordingLoading,
        'STOP_RECORDING_DONE' => stopRecordingDone,
        'CANCEL_RECORDING_LOADING' => cancelRecordingLoading,
        'CANCEL_RECORDING_DONE' => cancelRecordingDone,
        'STANDBY' => standby,
        _ => () {
            if (value.startsWith('RFID')) return rfId;
            if (value.startsWith('SIZE')) return size;
            if (value.startsWith('STANDBY')) return standby;
            if (value.startsWith('START_STATUS')) return startStatus;
            if (value.startsWith('STOP_STATUS')) return stopStatus;
            if (value.startsWith('CANCEL_STATUS')) return cancelStatus;
            return unknown;
          }(),
      };
}
