import 'dart:async';
import 'dart:io';

import 'package:overlay_app/model/string_communication.dart';
import 'package:rxdart/subjects.dart';
import 'package:universal_socket/universal_socket.dart';

import '../model/command.dart';

const _udpPort = 1101;
const _clientType = 'ANDROID_INTERFACE';
// const _visitId = 'VISIT_ID:';

const commandDelay = 1000;

class SendCommandController {
  String _address = '';
  int? _port;

  // static const _AuthToken = 'AUTH_TOKEN';
  UniversalSocket? _socket;
  StreamSubscription? _udpSub;
  final _controller = BehaviorSubject<TCPRequest>();
  // final SharedPreferences _preferences;

  SendCommandController(
      // this._preferences,
      );

  Future<void> connect(String visitId, Function() onConnected) async {
    try {
      await RawDatagramSocket.bind(InternetAddress.anyIPv4, _udpPort)
          .then((socket) {
        Logger.log('Start Listening on port $_udpPort ...');
        socket.broadcastEnabled = true;
        _udpSub = socket.listen((event) {
          if (event == RawSocketEvent.read) {
            final dg = socket.receive();
            if (dg == null) return;
            final message = String.fromCharCodes(dg.data);
            if (!_handleIp(message)) return;
            Logger.log('UDP Received: $_address:$_port');
            socket.close();
            _udpSub?.cancel();
            _connectTo(visitId, onConnected);
          }
        });
      }).onError(
        (error, stackTrace) {
          Logger.log(error);
        },
      );
    } catch (error) {
      Logger.log(error);
    }
  }

  Future<void> disconnect() async {
    _udpSub?.cancel();
    _socket?.disconnect();
    _controller.close();
  }

  Stream<StringCommunication> listenForCommand() => _controller.stream
      .skipWhile((element) => switch (element.command) {
            TCPCommand.sendMessage => false,
            TCPCommand.sendFile || TCPCommand.unknown => true,
          })
      .map<StringCommunication>(
          (event) => StringCommunication(event.body as String));

  Future<void> sendCommand(Command command) async =>
      await sendStringCommand(command.stringValue);

  Future<void> sendStringCommand(String command) async {
    if (_socket == null) return;

    Logger.log('Sending command $command.');
    await _socket!.sendMessage(command);
  }

  bool _handleIp(String message) {
    if (!message.startsWith('||') && !message.endsWith('||')) return false;
    final temp = message.substring(2, message.length - 2).split(':');
    if (temp.length != 2) return false;
    _address = temp[0];
    _port = int.parse(temp[1]);
    return true;
  }

  void _connectTo(String visitId, Function() onConnected) async {
    if (_port == null) return;
    if (_address.isEmpty) return;
    final config = ConnectionConfig(
      ipAddress: _address,
      port: _port!,
    );
    _socket = UniversalSocket(config);
    try {
      final isConnected = await _socket!.connect();
      if (!isConnected) {
        Logger.log('Cannot connect to ${config.ipAddress}:${config.port}');
        return;
      }
      _listenToServer();
      await sendMessage(_clientType);
      await Future.delayed(const Duration(milliseconds: commandDelay));
      await sendMessage('${Command.visitId.stringValue}:$visitId');
      await Future.delayed(const Duration(milliseconds: commandDelay));
      Logger.log('Start listening...');
      onConnected();
    } catch (error) {
      Logger.log(error);
    }
  }

  void _listenToServer() {
    if (_socket == null) return;
    _socket!.addListener((event) {
      Logger.log('Message Received: $event');
      if (_controller.isClosed) return;
      _controller.add(event);
    });
  }

  // Future<void> saveFile(XFile file) async {
  //   final extension =
  //       file.mimeType == null ? 'mp4' : extensionFromMime(file.mimeType!);
  //   final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
  //   path = '${Directory.systemTemp.path}/$fileName';
  //   final newFile = File(path);
  //   if (newFile.existsSync()) {
  //     newFile.deleteSync();
  //   }
  //   newFile.createSync();
  //   newFile.writeAsBytes(await file.readAsBytes());
  //   Logger.log('File save at $path');
  // }

  Stream<double> uploadFile(File file) async* {
    if (_socket == null) return;
    // final file = File(path);
    // if (!file.existsSync()) {
    //   yield const Left(ServerFailure(message: 'File not found'));
    //   return;
    // }
    Logger.log('Start uploading file');
    yield* _socket!.uploadFile(file);
  }

  // @override
  // String get getToken => _preferences.getString(_AuthToken) ?? '';

  // @override
  // Future<void> saveToken(String token) =>
  //     _preferences.setString(_AuthToken, token);

  Future<void> sendMessage(String message) async {
    if (_socket == null) return;
    await _socket!.sendMessage(message);
  }

  Stream<bool> connectionStream() =>
      _socket?.connectionStream() ?? Stream.value(false);
}
