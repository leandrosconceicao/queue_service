import 'package:queue_service/tools/date_functions.dart';

class Queue {
  String? id;
  int? position;
  String? date;
  String? storeCode;

  Queue({
    this.id,
    this.position,
    this.date,
    this.storeCode,
  });

  Queue.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    position = json['position'];
    storeCode = json['storeCode'];
    date = json['date'] != null ? FormatDate.standard(json['date']) : null;
  }

  static List<Queue?> toList(List json) => json.map((e) => Queue.fromJson(e)).toList();


}
