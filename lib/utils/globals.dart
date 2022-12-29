import 'package:flutter/foundation.dart';
import 'package:queue_service/models/queue.dart';

// const websocketUrl = String.fromEnvironment('urlSocket');
const requestUrl =  kDebugMode ? 'http://192.168.63.238' : String.fromEnvironment('apiUrl');
const storeCode = kDebugMode ? '9999' : String.fromEnvironment('storeCode');

Queue? selectedQueue;