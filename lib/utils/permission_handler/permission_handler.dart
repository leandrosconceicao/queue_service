import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> request() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
  }
}