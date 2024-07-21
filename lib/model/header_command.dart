enum HeaderCommand {
  size,
  rfId,
  startRecordingLoading,
  startRecordingDone,
  stopRecordingLoading,
  stopRecordingDone,
  standby,
  unknown;

  String get stringValue => switch (this) {
        size => 'SIZE',
        rfId => 'RFID',
        startRecordingLoading => 'START_RECORDING_LOADING',
        startRecordingDone => 'START_RECORDING_DONE',
        stopRecordingLoading => 'STOP_RECORDING_LOADING',
        stopRecordingDone => 'STOP_RECORDING_DONE',
        standby => 'STAND_BY',
        unknown => 'UNKNOWN',
      };

  static HeaderCommand fromString(String value) => switch (value) {
        'START_RECORDING_LOADING' => startRecordingLoading,
        'START_RECORDING_DONE' => startRecordingDone,
        'STOP_RECORDING_LOADING' => stopRecordingLoading,
        'STOP_RECORDING_DONE' => stopRecordingDone,
        'STANDBY' => standby,
        _ => () {
            if (value.startsWith('RFID')) return rfId;
            if (value.startsWith('SIZE')) return size;
            if (value.startsWith('STANDBY')) return standby;
            return unknown;
          }(),
      };
}
