import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

final appCon = AppController();

class AppController extends GetxController {
  Map<String, String> headers = {};
  final selectedPrinter = Rxn<BluetoothInfo>(null);
}