import 'package:flutter/material.dart';

enum ButtonType {
  startRecording,
  stopRecording;

  Color get toColor => switch (this) {
        ButtonType.startRecording => Colors.green,
        ButtonType.stopRecording => Colors.red,
      };

  String get toStringValue => switch (this) {
        ButtonType.startRecording => 'STRT',
        ButtonType.stopRecording => 'STOP'
      };
}
