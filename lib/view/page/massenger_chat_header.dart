import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    // if (homePort != null) return;
    // final res = IsolateNameServer.registerPortWithName(
    //   _receivePort.sendPort,
    //   _kPortNameOverlay,
    // );
    // log("$res : HOME");
    // _receivePort.listen((message) {
    //   log("message from UI: $message");
    //   setState(() {
    //     messageFromOverlay = 'message from UI: $message';
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
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
          child: const Center(
            child: FlutterLogo(),
          ),
        ),
      ),
    );
  }

  void _onTap() {
    homePort ??= IsolateNameServer.lookupPortByName(_kPortNameHome);
    homePort?.send('TAKE_SCREEN_SHOT');
  }
}
