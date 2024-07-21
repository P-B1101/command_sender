import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:rxdart/subjects.dart';
import 'package:universal_socket/universal_socket.dart';

import '../../controller/pop_up_controller.dart';
import '../../controller/send_command_controller.dart';
import '../../core/utils/utils.dart';
import '../../model/command.dart';
import '../../model/header_command.dart';
import '../../model/string_communication.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _sendCommandController = SendCommandController();
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
      body: SizedBox(
        width: double.infinity,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _onStartClick,
                child: const Text('Start'),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _onStopClick,
                child: const Text('Stop'),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: SizedBox(
                      width: double.infinity,
                      child: StreamBuilder<String>(
                        initialData: '',
                        stream: LogObserver.instance.observer,
                        builder: (context, snapshot) => Text(
                          snapshot.data ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleInitState() {
    if (_port != null) return;
    _checkForUsibility();
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
    if (await FlutterOverlayWindow.isActive()) {
      Logger.log('Overlay window is already active');
      return;
    }
    if (!mounted) return;
    final visitId = await PopUpController.showVisitIdPopup(context);
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
        await _sendCommandController.sendStringCommand(message);
        _sendCommand(HeaderCommand.startRecordingLoading);
        break;
      case Command.stopRecording:
        await _sendCommandController.sendCommand(command);
        _sendCommand(HeaderCommand.stopRecordingLoading);
        break;
      case Command.standby:
      case Command.rfId:
      case Command.token:
      case Command.unknown:
      case Command.visitId:
      case Command.dateTime:
        break;
    }
  }

  void _listenToSocket(StringCommunication message) {
    switch (message.getCommand) {
      case Command.startRecording:
        _sendCommand(HeaderCommand.startRecordingDone);
        break;
      case Command.stopRecording:
        _sendCommand(HeaderCommand.stopRecordingDone);
        break;
      case Command.rfId:
        final rfId = message.getRFId;
        if (rfId == null) break;
        _sendStringCommand('${HeaderCommand.rfId.stringValue}:$rfId');
        break;
      case Command.standby:
        final standby = message.getStandby;
        if (standby == null) break;
        _sendStringCommand('${HeaderCommand.standby.stringValue}:$standby');
        break;
      case Command.unknown:
      case Command.token:
      case Command.visitId:
      case Command.dateTime:
        break;
    }
  }

  void _sendCommand(HeaderCommand command) =>
      _sendStringCommand(command.stringValue);

  void _sendStringCommand(String command) {
    _port ??= IsolateNameServer.lookupPortByName(_kPortNameHeader);
    _port?.send(command);
  }

  Future<void> _checkForUsibility() async {
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
      Logger.log('Overlay window is already active');
      return;
    }
  }

  Future<void> _startOverWindow() async {
    await _checkForUsibility();
    Logger.log('Start show overlay window');
    if (!mounted) return;
    final size = MediaQuery.sizeOf(context);
    final ratio = MediaQuery.devicePixelRatioOf(context);
    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      overlayTitle: 'iClassifier',
      overlayContent: 'iClassifier command sender',
      flag: OverlayFlag.focusPointer,
      positionGravity: PositionGravity.left,
      alignment: OverlayAlignment.topRight,
      width: (Utils.headerInitialWidth * ratio).toInt(),
      height: (Utils.headerInitialHeight * ratio).toInt(),
      startPosition: const OverlayPosition(0, 24),
    );
    _sendStringCommand(
        '${HeaderCommand.size.stringValue}:${size.width}:${size.height}');
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
}
