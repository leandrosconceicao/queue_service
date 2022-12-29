import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/api_responses.dart';

GetSnackBar appSnackBar(
  String msg, {
  String? actionLabel,
  void Function()? onPressed,
  Duration? duration,
  ApiRes? response,
}) {
  return GetSnackBar(
    duration: duration ?? const Duration(seconds: 5),
    icon: const Icon(Icons.priority_high),
    message: msg,
    snackStyle: SnackStyle.FLOATING,
    mainButton: TextButton(
      onPressed: () => Get.closeAllSnackbars(),
      child: const Text('Fechar'),
    ),
  );
}