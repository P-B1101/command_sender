import 'package:flutter/material.dart';

enum ButtonType {
  takeScreenShot,
  openCamera,
  startRecording,
  stopRecording;

  Color get toColor => switch (this) {
        ButtonType.takeScreenShot => Colors.orange,
        ButtonType.openCamera => Colors.green,
        ButtonType.startRecording => Colors.red,
        ButtonType.stopRecording => Colors.amber,
      };

  String get toStringValue => switch (this) {
        ButtonType.takeScreenShot => 'SS',
        ButtonType.openCamera => 'OC',
        ButtonType.startRecording => 'STRT',
        ButtonType.stopRecording => 'STP'
      };
}
