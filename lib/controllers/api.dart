import 'dart:async';

import 'package:queue_service/models/api_calls.dart';
import 'package:queue_service/models/app_controller.dart';
import 'package:queue_service/utils/printer_services/printer_service.dart';

import '../models/api_responses.dart';
import '../models/endpoints.dart';
import '../models/queue.dart';
import '../utils/globals.dart';

class QueueService {

  static final bloc = StreamController<ApiRes<List<Queue?>?>?>.broadcast();
  static final lastCallsbloc = StreamController<ApiRes<List<Queue?>?>?>.broadcast();

  static Future<ApiRes<List<Queue?>>> next() async {
    return Api.request<List<Queue?>>(
      method: ApiMethods.get,
      endpoint: '${Endpoints.queue}/$storeCode',
      function: Queue.toList
    );
  }
   
  static Future<ApiRes<List<Queue?>>> fetchAll() async {
    return Api.request<List<Queue?>>(
      method: ApiMethods.get,
      endpoint: '${Endpoints.queue}?storeCode=$storeCode',
      function: Queue.toList
    );
  }

  static Future<ApiRes<List<Queue?>>> clear() async {
    return Api.request<List<Queue?>>(
      method: ApiMethods.del,
      endpoint: '${Endpoints.queue}/$storeCode',
    );
  }

  static Future<void> clearQueue(Function callbackIfError) async {
    ApiRes r = await clear();
    if (!r.result) {
      callbackIfError();
    } else {
      bloc.add(null);
    }
  }

  static Future<void> loadNext(Function callbackIfErrorOnPrint) async {
    bloc.add(null);
    final r = await next();
    if (r.result && appCon.selectedPrinter.value != null && (r.data?.isNotEmpty ?? false)) {
      PrinterService.printQueue(r.data!.first!, callbackIfErrorOnPrint);
    }
    bloc.add(r);
  }

  static Future<void> loadAll() async {
    lastCallsbloc.add(null);
    final req = await fetchAll();
    lastCallsbloc.add(req);
  }
}
