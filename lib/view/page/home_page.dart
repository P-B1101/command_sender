import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

// import 'package:device_screenshot/device_screenshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:overlay_app/controller/pop_up_controller.dart';
import 'package:overlay_app/controller/send_command_controller.dart';
import 'package:overlay_app/model/command.dart';
import 'package:overlay_app/model/loading_command.dart';
import 'package:overlay_app/model/string_communication.dart';
import 'package:rxdart/subjects.dart';
import 'package:universal_socket/universal_socket.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final _sendCommandController = SendCommandController();

class _HomePageState extends State<HomePage> {
  static const String _kPortNameHome = 'UI';
  static const String _kPortNameHeader = 'HEADER';
  final _receivePort = ReceivePort();
  SendPort? _port;
  StreamSubscription<StringCommunication>? _sub;
  static final _controller = BehaviorSubject<String>();

  @override
  void initState() {
    super.initState();
    _handleInitState();
  }

  @override
  void dispose() {
    _onStopClick();
    _controller.close();
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
    if (_port != null) return;
    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameHome,
    );
    _receivePort.listen((message) {
      _handleMessage(message);
    });
    _controller.listen(_listenToHeader);
  }

  void _onStartClick() async {
    final visitId = await PopUpController.showVisigIdPopup(context);
    if (visitId == null) return;
    await _sendCommandController.connect(visitId);
    _sendCommandController.listenForCommand().listen(_listenToSocket);
    await _startOverWindow();
  }

  void _listenToHeader(String message) async {
    Logger.log('message from header: $message');
    final command = Command.fromString(message);
    switch (command) {
      case Command.startRecording:
        await _sendCommandController.sendCommand(command);
        _sendCommand(LoadingCommand.startRecordingLoading);
        break;
      case Command.stopRecording:
        await _sendCommandController.sendCommand(command);
        _sendCommand(LoadingCommand.stopRecordingLoading);
        break;
      case Command.token:
      case Command.unknown:
        break;
    }
  }

  void _listenToSocket(StringCommunication message) {
    switch (message.getCommand) {
      case Command.startRecording:
        _sendCommand(LoadingCommand.startRecordingLoading);
        break;
      case Command.stopRecording:
        _sendCommand(LoadingCommand.stopRecordingDone);
        break;
      case Command.unknown:
      case Command.token:
        break;
    }
  }

  void _sendCommand(LoadingCommand command) {
    _port ??= IsolateNameServer.lookupPortByName(_kPortNameHeader);
    _port?.send(command.stringValue);
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
    FlutterOverlayWindow.closeOverlay();
    _sub?.cancel();
    _sub = null;
    _sendCommandController.disconnect();
  }

  static void _handleMessage(String message) async {
    if (_controller.isClosed) return;
    _controller.add(message);
  }

  static int get _width => 800;
  static int get _height => 800;
}
