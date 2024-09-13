import 'package:get_it/get_it.dart';
import 'package:overlay_app/controller/send_command_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final info = await PackageInfo.fromPlatform();
  getIt.registerLazySingleton<PackageInfo>(
    () => info,
  );
  getIt.registerLazySingleton<SendCommandController>(
    () => SendCommandController(getIt<PackageInfo>()),
  );
}
