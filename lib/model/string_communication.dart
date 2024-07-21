import 'package:overlay_app/model/command.dart';
import 'package:overlay_app/model/communication.dart';

class StringCommunication extends Communication {
  final String data;
  const StringCommunication(this.data);

  @override
  List<Object?> get props => [data];

  Command get getCommand => Command.fromString(data);

  String? get getRFId => getCommand == Command.rfId ? data : null;

  bool? get getStandby => getCommand == Command.standby
      ? data.toLowerCase() == 'true'
      : data.toLowerCase() == 'false'
          ? false
          : null;
}
