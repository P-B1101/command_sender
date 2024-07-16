import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:overlay_app/model/command.dart';

import '../../model/button_type.dart';

class MessangerChatHead extends StatefulWidget {
  const MessangerChatHead({super.key});

  @override
  State<MessangerChatHead> createState() => _MessangerChatHeadState();
}

class _MessangerChatHeadState extends State<MessangerChatHead> {
  Color color = const Color(0xFFFFFFFF);
  static const String _kPortNameHome = 'UI';
  SendPort? homePort;
  String? messageFromOverlay;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
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
            end: _isOpen ? _buttonSize * .75 : -16,
            top: _isOpen ? 0 : _topPadding,
            child: _ButtonWidget(
              size: _childButtonSize,
              type: ButtonType.takeScreenShot,
              onTap: _onTakeScreenShot,
            ),
          ),
          AnimatedPositionedDirectional(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
            end: _isOpen ? _buttonSize + _startPadding + _startPadding : -16,
            top: _isOpen ? _childButtonSize : _topPadding,
            child: _ButtonWidget(
              size: _childButtonSize,
              type: ButtonType.openCamera,
              onTap: _onOpenCamera,
            ),
          ),
          AnimatedPositionedDirectional(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
            end: _isOpen ? (_buttonSize * 1.25) : -16,
            top: _isOpen
                ? (_childButtonSize * 2) + (_childButtonPadding)
                : _topPadding,
            child: _ButtonWidget(
              size: _childButtonSize,
              type: ButtonType.startRecording,
              onTap: _onStartRecording,
            ),
          ),
          AnimatedPositionedDirectional(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
            end: _isOpen ? (_buttonSize * .75) : -16,
            top: _isOpen
                ? (_childButtonSize * 3) + (_childButtonPadding * 2)
                : _topPadding,
            child: _ButtonWidget(
              size: _childButtonSize,
              type: ButtonType.stopRecording,
              onTap: _onStopRecording,
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

  void _onTap() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  void _sendCommand(Command command) {
    homePort ??= IsolateNameServer.lookupPortByName(_kPortNameHome);
    homePort?.send(command.stringValue);
  }

  void _onTakeScreenShot() {
    _sendCommand(Command.takeScreenShot);
  }

  void _onOpenCamera() {
    _sendCommand(Command.openCamera);
  }

  void _onStartRecording() {
    _sendCommand(Command.startRecording);
  }

  void _onStopRecording() {
    _sendCommand(Command.stopRecording);
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
  const _ButtonWidget({
    required this.type,
    required this.onTap,
    required this.size,
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
                onTap: onTap,
                child: Center(
                  child: Text(
                    type.toStringValue,
                    style: Theme.of(context).textTheme.bodySmall,
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
