import 'package:overlay_app/model/command.dart';
import 'package:overlay_app/model/communication.dart';

class StringCommunication extends Communication {
  final String data;
  const StringCommunication(this.data);

  @override
  List<Object?> get props => [data];

  Command get getCommand => Command.fromString(data);

  String? get getRFId {
    if (getCommand != Command.rfId) return null;
    final temp = data.split(':');
    if (temp.length != 2) return null;
    return temp[1];
  }

  bool? get getStandby {
    if (getCommand != Command.standby) return null;
    final temp = data.split(':');
    if (temp.length != 2) return null;
    final newTemp = temp[1].toLowerCase();
    if (newTemp == 'true') return true;
    if (newTemp == 'false') return false;
    return null;
  }
}
