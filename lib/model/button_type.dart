import 'package:flutter/material.dart';

enum ButtonType {
  startRecording,
  stopRecording,
  cancelRecording;

  Color get toColor => switch (this) {
        startRecording => Colors.green,
        stopRecording => Colors.red,
        cancelRecording => Colors.orange,
      };

  String get toStringValue => switch (this) {
        startRecording => 'STRT',
        stopRecording => 'STOP',
        cancelRecording => 'CANCEL',
      };
}
