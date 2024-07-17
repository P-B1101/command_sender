import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:device_screenshot/device_screenshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:overlay_app/controller/send_command_controller.dart';
import 'package:overlay_app/model/command.dart';
import 'package:universal_socket/universal_socket.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final _sendCommandController = SendCommandController();

class _HomePageState extends State<HomePage> {
  static const String _kPortNameHome = 'UI';
  final _receivePort = ReceivePort();
  SendPort? homePort;
  // final _sendCommandController = SendCommandController();

  @override
  void initState() {
    super.initState();
    _handleInitState();
  }

  @override
  void dispose() {
    _onStopClick();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: _onStartClick,
              child: const Text('Start'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _onStopClick,
              child: const Text('Stop'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleInitState() {
    if (homePort != null) return;
    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameHome,
    );
    _receivePort.listen((message) {
      _handleMessage(message);
    });
  }

  void _onStartClick() async {
    DeviceScreenshot.instance.requestMediaProjection();
    await _sendCommandController.connect();
    await _startOverWindow();
  }

  static Future<void> _startOverWindow() async {
    final status = await FlutterOverlayWindow.isPermissionGranted();
    Logger.log('Is Permission Granted: $status');
    if (!status) {
      final res = await FlutterOverlayWindow.requestPermission();
      if (res != true) {
        Logger.log('Permission is not Granted');
        return;
      }
    }
    if (await FlutterOverlayWindow.isActive()) {
      Logger.log('Overlay window is not active');
      return;
    }
    Logger.log('Start show overlay window');
    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      overlayTitle: 'iClassifier',
      overlayContent: 'iClassifier command sender',
      flag: OverlayFlag.defaultFlag,
      positionGravity: PositionGravity.auto,
      alignment: OverlayAlignment.topRight,
      height: _height,
      width: _width,
      startPosition: const OverlayPosition(0, 42),
    );
  }

  void _onStopClick() {
    DeviceScreenshot.instance.stopMediaProjectionService();
    FlutterOverlayWindow.closeOverlay();
    _sendCommandController.disconnect();
  }

  static void _handleMessage(String message) async {
    Logger.log('message from overlay: $message');
    final command = Command.fromString(message);
    switch (command) {
      case Command.takeScreenShot:
        _takeScreenshot();
        break;
      case Command.openCamera:
      case Command.startRecording:
      case Command.stopRecording:
        await _sendCommandController.sendCommand(command);
        break;
      case Command.authentication:
      case Command.token:
      case Command.sendVideo:
      case Command.unknown:
        break;
    }
  }

  static Future<void> _takeScreenshot() async {
    await FlutterOverlayWindow.closeOverlay();
    await Future.delayed(const Duration(milliseconds: 100));
    final uri = await DeviceScreenshot.instance.takeScreenshot();
    _startOverWindow();
    if (uri == null) return;
    final file = File.fromUri(uri);
    _sendCommandController.uploadFile(file).listen((progress) {
      Logger.log('${(progress * 100).toStringAsFixed(2)}% uploaded');
    });
  }

  static int get _width => 800;
  static int get _height => 800;
}
