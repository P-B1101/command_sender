enum Command {
  authentication,
  token,
  takeScreenShot,
  openCamera,
  startRecording,
  stopRecording,
  sendVideo,
  unknown;

  String get stringValue => switch (this) {
        authentication => 'AUTHENTICATION',
        token => 'TOKEN',
        takeScreenShot => 'TAKE_SCREEN_SHOT',
        openCamera => 'OPEN_CAMERA',
        startRecording => 'START_RECORDING',
        stopRecording => 'STOP_RECORDING',
        sendVideo => 'SEND_VIDEO',
        unknown => 'UNKNOWN',
      };

  static Command fromString(String value) => switch (value) {
        'AUTHENTICATION' => authentication,
        'TOKEN' => token,
        'OPEN_CAMERA' => openCamera,
        'TAKE_SCREEN_SHOT' => takeScreenShot,
        'START_RECORDING' => startRecording,
        'STOP_RECORDING' => stopRecording,
        'SEND_VIDEO' => sendVideo,
        _ => unknown,
      };
}
