import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:universal_socket/universal_socket.dart';

import '../../controller/pop_up_controller.dart';
import '../../model/button_type.dart';
import '../../model/command.dart';
import '../../model/loading_command.dart';
import '../widget/circular_loading_widget.dart';

class MessangerChatHead extends StatefulWidget {
  const MessangerChatHead({super.key});

  @override
  State<MessangerChatHead> createState() => _MessangerChatHeadState();
}

class _MessangerChatHeadState extends State<MessangerChatHead> {
  final _startLoading = ValueNotifier<bool>(false);
  final _stopLoading = ValueNotifier<bool>(false);
  static const String _kPortNameHome = 'UI';
  static const String _kPortNameHeader = 'HEADER';
  final _receivePort = ReceivePort();
  static final _controller = BehaviorSubject<String>();
  SendPort? _port;
  bool _isOpen = false;
  String? _refId;

  @override
  void initState() {
    super.initState();
    _handleInitState();
  }

  @override
  void dispose() {
    _startLoading.dispose();
    _stopLoading.dispose();
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
      opacity: _isOpen ? 1 : .5,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.topEnd,
        children: [
          AnimatedPositionedDirectional(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
            end: _isOpen ? (_buttonSize * 1.25) : -16,
            top: _isOpen
                ? (_childButtonSize * 2) + (_childButtonPadding)
                : _topPadding,
            child: ValueListenableBuilder<bool>(
              valueListenable: _startLoading,
              builder: (context, value, child) => _ButtonWidget(
                isLoading: value,
                size: _childButtonSize,
                type: ButtonType.startRecording,
                onTap: _onStartRecording,
              ),
            ),
          ),
          AnimatedPositionedDirectional(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
            end: _isOpen ? (_buttonSize * .75) : -16,
            top: _isOpen
                ? (_childButtonSize * 3) + (_childButtonPadding * 2)
                : _topPadding,
            child: ValueListenableBuilder<bool>(
              valueListenable: _startLoading,
              builder: (context, value, child) => _ButtonWidget(
                isLoading: value,
                size: _childButtonSize,
                type: ButtonType.stopRecording,
                onTap: _onStopRecording,
              ),
            ),
          ),
          AnimatedPositionedDirectional(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
            end: _isOpen ? _startPadding : -16,
            top: _topPadding,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
              height: _buttonSize,
              width: _buttonSize,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent,
                elevation: 0.0,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _onTap,
                  child: Center(
                    child: ClipOval(
                      child: Image.asset('assets/image/logo.jpg'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleInitState() {
    if (_port != null) return;
    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameHeader,
    );
    _receivePort.listen((message) {
      _handleMessage(message);
    });
    _controller.listen(_listenForMessage);
  }

  void _listenForMessage(String message) {
    Logger.log('message from home: $message');
    final loading = HeaderCommand.fromString(message);
    switch (loading) {
      case HeaderCommand.startRecordingLoading:
        _startLoading.value = true;
        break;
      case HeaderCommand.startRecordingDone:
        _startLoading.value = false;
        break;
      case HeaderCommand.stopRecordingLoading:
        _stopLoading.value = true;
        break;
      case HeaderCommand.stopRecordingDone:
        _stopLoading.value = false;
        break;
      case HeaderCommand.refId:
        _refId =
            message.substring(message.indexOf('${loading.stringValue}:') + 1);
        break;
      case HeaderCommand.unknown:
        break;
    }
  }

  void _onTap() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  void _sendCommand(Command command) => _sendStringCommand(command.stringValue);

  void _sendStringCommand(String command) {
    _port ??= IsolateNameServer.lookupPortByName(_kPortNameHome);
    _port?.send(command);
  }

  // void _onTakeScreenShot() {
  //   _sendCommand(Command.takeScreenShot);
  // }

  // void _onOpenCamera() {
  //   _sendCommand(Command.openCamera);
  // }

  void _onStartRecording() async {
    final cowAndRefId = await PopUpController.showCowIdPopup(
      context: context,
      refId: _refId,
    );
    if (cowAndRefId?.serialize == null) return;
    _sendStringCommand(
        '${Command.startRecording.stringValue}:${cowAndRefId!.serialize}');
  }

  void _onStopRecording() {
    _sendCommand(Command.stopRecording);
    _refId = null;
  }

  static void _handleMessage(String message) async {
    if (_controller.isClosed) return;
    _controller.add(message);
  }

  double get _buttonSize => 56;
  double get _childButtonSize => 48;
  double get _startPadding => 8;
  double get _topPadding => 75;
  double get _childButtonPadding => 8;
}

class _ButtonWidget extends StatelessWidget {
  final ButtonType type;
  final Function() onTap;
  final double size;
  final bool isLoading;
  const _ButtonWidget({
    required this.type,
    required this.onTap,
    required this.size,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: type.toColor.withOpacity(.5),
              ),
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: type.toColor.withOpacity(.5),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: isLoading ? null : onTap,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: isLoading
                        ? const CircularLoadingWidget()
                        : Text(
                            type.toStringValue,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
