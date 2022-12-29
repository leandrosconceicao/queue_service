import 'dart:async';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:queue_service/models/api_responses.dart';
import 'package:queue_service/models/app_controller.dart';
import 'package:queue_service/views/components/custom_snackbar.dart';

import '../permission_handler/permission_handler.dart';

class Devices {

  static final bloc = StreamController<ApiRes?>.broadcast();

  static Future<ApiRes> getDevices() async {
    try {
      final List<BluetoothInfo> bluetooths = await PrintBluetoothThermal.pairedBluetooths;
      return ApiRes(result: true, message: 'Success', data: bluetooths);
    } catch (e) {
      return ApiRes.unknow(err: e);
    }
  }

  static Future<ApiRes> isConnected() async {
    try {
      bool req = await PrintBluetoothThermal.connectionStatus;
      return ApiRes(result: req, message: req ? 'Success' : 'no connection');
    } catch (e) {
      return ApiRes.unknow(err: e);
    }
  }

  static Future<ApiRes> connect() async {
    try {
      final req = await PrintBluetoothThermal.connect(macPrinterAddress: appCon.selectedPrinter.value!.macAdress);
      return ApiRes(result: req, message: !req ? 'Não foi possível conectar a impressora' : 'Success' );
    } catch (e) {
      return ApiRes.connError();
    }
  }

  static Future<void> loadPrinters() async {
    appCon.selectedPrinter.value = null;
    await PermissionService.request();
    if (await Permission.bluetoothConnect.isGranted) {
      bloc.add(null);
      bloc.add(await getDevices());
    } else {
      Get.showSnackbar(appSnackBar('Necessário conceder permissão para o aplicativo utilizar o bluetooth'));
    }
  }
}