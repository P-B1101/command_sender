import 'package:overlay_app/model/command.dart';
import 'package:overlay_app/model/communication.dart';

class StringCommunication extends Communication {
  final String data;
  const StringCommunication(this.data);

  @override
  List<Object?> get props => [data];

  Command get getCommand => Command.fromString(data);

  String? get getRefId => getCommand == Command.refId ? data : null;
}
