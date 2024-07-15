enum Command {
  authentication,
  token,
  startRecording,
  stopRecording,
  sendVideo,
  unknown;

  String get stringValue => switch (this) {
        authentication => 'AUTHENTICATION',
        token => 'TOKEN',
        startRecording => 'START_RECORDING',
        stopRecording => 'STOP_RECORDING',
        sendVideo => 'SEND_VIDEO',
        unknown => 'UNKNOWN',
      };

  static Command fromString(String value) => switch (value) {
        'AUTHENTICATION' => authentication,
        'TOKEN' => token,
        'START_RECORDING' => startRecording,
        'STOP_RECORDING' => stopRecording,
        'SEND_VIDEO' => sendVideo,
        _ => unknown,
      };
}
